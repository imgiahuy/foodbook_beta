import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/register_pages.dart';


void main() {
  testWidgets('RegisterPages renders and user can enter data and tap buttons', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: RegisterPages(),
        ),
      ),
    );

    // Find input fields by hint text
    final emailField = find.widgetWithText(TextFormField, 'Email adresse');
    final passwordField = find.widgetWithText(TextFormField, 'Password');
    final usernameField = find.widgetWithText(TextFormField, 'User name');

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(usernameField, findsOneWidget);

    // Enter text into fields
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'mypassword');
    await tester.enterText(usernameField, 'tester');

    final avatar = find.byType(CircleAvatar);
    expect(avatar, findsOneWidget);
    await tester.tap(avatar);
    await tester.pump();

    final signUpButton = find.byType(ElevatedButton);
    expect(signUpButton, findsWidgets);

    await tester.tap(signUpButton.first);
    await tester.pump();

  });
}
