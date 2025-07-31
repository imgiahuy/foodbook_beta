import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/presentation/controller/post_controller.dart';
import 'package:foodbook_beta/features/posten/presentation/state/post_controller_provider.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/book_pages.dart';
import 'package:mocktail/mocktail.dart';

// Mock PostController
class MockPostController extends Mock implements PostController {}

void main() {
  late MockPostController mockController;

  setUp(() {
    mockController = MockPostController();

    // Sample posts, some matching username, some not
    final posts = [
      PostContent(
        postid: '1',
        username: 'user1',
        image: 'https://example.com/image1.jpg',
        avatarUrl: null,
        recipe: 'Recipe 1',
        liked: false,
        likeCount: 0,
      ),
      PostContent(
        postid: '2',
        username: 'user2',
        image: 'https://example.com/image2.jpg',
        avatarUrl: null,
        recipe: 'Recipe 2',
        liked: true,
        likeCount: 5,
      ),
    ];

    when(() => mockController.getCurrentUsername()).thenAnswer((_) async => 'user1');
    when(() => mockController.loadPosts()).thenAnswer((_) async {});
    when(() => mockController.posts).thenReturn(posts);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        postControllerProvider.overrideWithValue(mockController),
      ],
      child: const MaterialApp(
        home: BookPage(),
      ),
    );
  }

  testWidgets('shows loading indicator while username is null', (tester) async {
    when(() => mockController.getCurrentUsername()).thenAnswer((_) async => null);

    await tester.pumpWidget(createWidgetUnderTest());

    // Initially a CircularProgressIndicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays only posts for current user in grid', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Let async tasks finish
    await tester.pumpAndSettle();

    // We expect only one post with username 'user1' to appear in the grid
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // The image URL for the post by user1 should be present in widget tree
    expect(find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is NetworkImage &&
          (widget.image as NetworkImage).url == 'https://example.com/image1.jpg',
    ), findsOneWidget);

    // The post for user2 should NOT be shown
    expect(find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is NetworkImage &&
          (widget.image as NetworkImage).url == 'https://example.com/image2.jpg',
    ), findsNothing);
  });

  testWidgets('shows "No posts found" if user has no posts', (tester) async {
    when(() => mockController.getCurrentUsername()).thenAnswer((_) async => 'user3'); // no posts for user3
    when(() => mockController.posts).thenReturn([
      PostContent(postid: '1', username: 'user1', image: null, avatarUrl: null, recipe: '', liked: false, likeCount: 0)
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('No posts found'), findsOneWidget);
  });
}

extension on ChangeNotifierProvider<PostController> {
  overrideWithValue(MockPostController mockController) {}
}
