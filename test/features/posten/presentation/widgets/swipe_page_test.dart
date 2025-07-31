import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/presentation/controller/post_controller.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/post_editor_page.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/swipe_page.dart';
import 'package:mocktail/mocktail.dart';

// Mock PostController
class MockPostController extends Mock implements PostController {}

void main() {
  late MockPostController mockController;

  setUp(() {
    mockController = MockPostController();

    // Sample posts list
    final posts = [
      PostContent(postid: '1', username: 'user1', image: null, avatarUrl: null, recipe: 'Recipe 1', liked: false, likeCount: 0),
      PostContent(postid: '2', username: 'user2', image: null, avatarUrl: null, recipe: 'Recipe 2', liked: true, likeCount: 3),
    ];

    when(() => mockController.posts).thenReturn(posts);
    when(() => mockController.toggleLike(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        postControllerProvider.overrideWithValue(mockController),
      ],
      child: const MaterialApp(
        home: SwipePage(),
      ),
    );
  }

  testWidgets('renders Dismissible for each post', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Should find 2 Dismissible widgets initially
    expect(find.byType(Dismissible), findsNWidgets(2));
    expect(find.text('user1'), findsOneWidget);
    expect(find.text('user2'), findsOneWidget);
  });

  testWidgets('dismiss post removes it from visible list', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Swipe the first post left (endToStart)
    final firstDismissible = find.byKey(const Key('1'));
    expect(firstDismissible, findsOneWidget);

    await tester.drag(firstDismissible, const Offset(-500, 0));
    await tester.pumpAndSettle();

    // After dismiss, only 1 post left
    expect(find.byType(Dismissible), findsOneWidget);
    expect(find.text('user1'), findsNothing);
    expect(find.text('user2'), findsOneWidget);
  });

  testWidgets('tap like icon calls toggleLike', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Find first post's like icon (it depends on liked: false, so favorite_border icon)
    final likeIcon = find.descendant(
      of: find.byKey(const Key('1')),
      matching: find.byIcon(Icons.favorite_border),
    );
    expect(likeIcon, findsOneWidget);

    await tester.tap(likeIcon);
    await tester.pumpAndSettle();

    verify(() => mockController.toggleLike(any())).called(1);
  });

  testWidgets('floating action button navigates to PostEditor', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Should find PostEditor page
    expect(find.byType(PostEditor), findsOneWidget);
  });
}

extension on ChangeNotifierProvider<PostController> {
  overrideWithValue(MockPostController mockController) {}
}
