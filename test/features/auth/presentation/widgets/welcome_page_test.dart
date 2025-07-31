import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/welcome_pages.dart';

void main() {
  testWidgets('WelcomePages renders and buttons are tappable', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: WelcomePages(),
        ),
      ),
    );
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.textContaining(''), findsWidgets);
    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');

    expect(signInButton, findsOneWidget);
    expect(signUpButton, findsOneWidget);

    await tester.tap(signInButton);
    await tester.pump();

    await tester.tap(signUpButton);
    await tester.pump();
  });
}
