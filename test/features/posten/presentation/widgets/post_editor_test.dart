
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/posten/presentation/controller/post_controller.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/post_editor_page.dart';
import 'package:mocktail/mocktail.dart';

class MockPostController extends Mock implements PostController {}

void main() {
  late MockPostController mockController;

  setUp(() {
    mockController = MockPostController();

    when(() => mockController.recipe).thenReturn('');
    when(() => mockController.image).thenReturn(null);
    when(() => mockController.pickImage()).thenAnswer((_) async {});
    when(() => mockController.clearDraft()).thenReturn(null);
    when(() => mockController.setRecipe(any())).thenReturn(null);
    when(() => mockController.postContent()).thenAnswer((_) async => throw Exception('No user')); // default
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        postControllerProvider.overrideWithValue(mockController),
      ],
      child: const MaterialApp(
        home: PostEditor(),
      ),
    );
  }

  testWidgets('shows SnackBar when trying to post without image or recipe', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final postButton = find.byType(FloatingActionButton);
    expect(postButton, findsOneWidget);
    await tester.tap(postButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Please add an image and write a recipe before posting.'), findsOneWidget);
  });

  testWidgets('updates recipe text and calls setRecipe', (tester) async {
    when(() => mockController.recipe).thenReturn('');
    await tester.pumpWidget(createTestWidget());

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'New Recipe');
    verify(() => mockController.setRecipe('New Recipe')).called(1);
  });

  testWidgets('tap image container calls pickImage', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final container = find.byType(GestureDetector);
    expect(container, findsOneWidget);

    await tester.tap(container);
    verify(() => mockController.pickImage()).called(1);
  });
}

extension on ChangeNotifierProvider<PostController> {
  overrideWithValue(MockPostController mockController) {}
}
