import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/presentation/controller/post_controller.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/post_widget.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/surfen_page.dart';
import 'package:mocktail/mocktail.dart';

// Mock PostController
class MockPostController extends Mock implements PostController {}

void main() {
  late MockPostController mockController;

  setUp(() {
    mockController = MockPostController();

    // Default behavior: posts list empty
    when(() => mockController.posts).thenReturn([]);
    when(() => mockController.loadPosts()).thenAnswer((_) async {});
    when(() => mockController.toggleLike(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        postControllerProvider.overrideWithValue(mockController),
      ],
      child: const MaterialApp(
        home: SurfenPage(),
      ),
    );
  }

  testWidgets('shows "No posts yet" when posts list is empty', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('No posts yet'), findsOneWidget);
  });

  testWidgets('displays list of PostWidget when posts are present', (tester) async {
    // Create sample post
    final samplePost = PostContent(
      postid: '1',
      username: 'user',
      image: null,
      avatarUrl: null,
      recipe: 'Delicious recipe',
      liked: false,
      likeCount: 0,
    );

    // Override posts to non-empty list
    when(() => mockController.posts).thenReturn([samplePost]);

    await tester.pumpWidget(createWidgetUnderTest());

    // Because posts changed, pump again to update UI
    await tester.pump();

    expect(find.byType(PostWidget), findsOneWidget);
    expect(find.text('user'), findsOneWidget);
  });

  testWidgets('calls toggleLike on PostWidget like button tap', (tester) async {
    final samplePost = PostContent(
      postid: '1',
      username: 'user',
      image: null,
      avatarUrl: null,
      recipe: 'Delicious recipe',
      liked: false,
      likeCount: 0,
    );

    when(() => mockController.posts).thenReturn([samplePost]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Find the like icon (favorite_border icon)
    final likeIcon = find.byIcon(Icons.favorite_border);
    expect(likeIcon, findsOneWidget);

    await tester.tap(likeIcon);
    await tester.pumpAndSettle();

    verify(() => mockController.toggleLike(samplePost)).called(1);
  });
}

extension on ChangeNotifierProvider<PostController> {
  overrideWithValue(MockPostController mockController) {}
}
