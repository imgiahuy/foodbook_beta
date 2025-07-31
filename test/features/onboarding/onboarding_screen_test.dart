import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/onboarding/widgets/on_boarding_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('OnBoardingScreen displays all elements and navigates on button tap', (WidgetTester tester) async {
    // Mock GoRouter with test configuration
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OnBoardingScreen(),
        ),
        GoRoute(
          name: 'welcome',
          path: '/welcome',
          builder: (context, state) => const Scaffold(body: Text('Welcome Screen')),
        ),
      ],
    );

    // Render widget
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    expect(find.text('What eat today'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);

    expect(find.byType(Image), findsNWidgets(3));

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Screen'), findsOneWidget);
  });
}
