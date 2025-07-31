import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodbook_beta/features/auth/presentation/widgets/login_pages.dart';

void main() {
  testWidgets('LoginPages renders and interacts with form fields and button', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: LoginPages(),
        ),
      ),
    );

    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');

    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');


    final elevatedButtons = find.byType(ElevatedButton);
    expect(elevatedButtons, findsWidgets);

    await tester.tap(elevatedButtons.first);
    await tester.pump();


  });
}
