import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/posten/domain/model/post.dart';
import 'package:foodbook_beta/features/posten/presentation/widgets/post_widget.dart';
import 'package:mocktail/mocktail.dart';

class MockLikeToggleCallback extends Mock {
  Future<void> call(PostContent post);
}

void main() {
  late MockLikeToggleCallback mockLikeToggle;
  late PostContent testPost;

  setUp(() {
    mockLikeToggle = MockLikeToggleCallback();

    testPost = PostContent(
      postid: '123',
      username: 'testuser',
      image: 'https://example.com/image.jpg',
      avatarUrl: 'https://example.com/avatar.jpg',
      recipe: 'Test recipe content',
      liked: false,
      likeCount: 5,
    );

    when(() => mockLikeToggle.call(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: PostWidget(
          post: testPost,
          onLikeToggle: mockLikeToggle.call,
        ),
      ),
    );
  }

  testWidgets('calls onLikeToggle when like icon tapped', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final likeIcon = find.byIcon(Icons.favorite_border);
    expect(likeIcon, findsOneWidget);

    await tester.tap(likeIcon);
    await tester.pumpAndSettle();

    verify(() => mockLikeToggle.call(testPost)).called(1);
  });

  testWidgets('shows recipe dialog when comment icon tapped', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final commentIcon = find.byIcon(Icons.comment);
    expect(commentIcon, findsOneWidget);

    await tester.tap(commentIcon);
    await tester.pumpAndSettle();

    expect(find.text('Recipe'), findsOneWidget);
    expect(find.text('Test recipe content'), findsOneWidget);

    final closeButton = find.text('Close');
    expect(closeButton, findsOneWidget);

    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    expect(find.text('Recipe'), findsNothing);
  });

  testWidgets('shows broken image icon when image fails to load', (tester) async {
    final postWithBadImage = testPost.copyWith(image: 'https://badurl');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostWidget(
            post: postWithBadImage,
            onLikeToggle: mockLikeToggle.call,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byIcon(Icons.broken_image), findsOneWidget);
  });
}
