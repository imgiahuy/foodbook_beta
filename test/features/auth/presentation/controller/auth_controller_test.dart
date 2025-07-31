import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/presentation/controller/login_controller.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_notifier.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/custom_text.dart';
import 'package:foodbook_beta/features/auth/presentation/feature_assets/image_path.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:foodbook_beta/shared/design_system/app_const.dart';
import 'package:foodbook_beta/shared/design_system/colors_digital.dart';

// Mock classes
class MockWidgetRef extends Mock implements WidgetRef {}
class MockAuthNotifier extends Mock implements AuthNotifier {}

// Fake class for User, needed for mocktail fallback
class FakeUser extends Fake implements User {}

void main() {
  late MockWidgetRef mockRef;
  late MockAuthNotifier mockAuthNotifier;

  setUpAll(() {
    // Register FakeUser as fallback value for User
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockRef = MockWidgetRef();
    mockAuthNotifier = MockAuthNotifier();
  });

  group('AuthController', () {
    test('signIn calls signIn on AuthNotifier', () {
      // Arrange: stub notifier provider and async signIn method
      when(() => mockRef.read(authNotifierProvider.notifier))
          .thenReturn(mockAuthNotifier as AuthNotifier);

      when(() => mockAuthNotifier.signIn(any(), any()))
          .thenAnswer((_) async {});

      final controller = AuthController(mockRef);
      final email = 'test@example.com';
      final password = 'password123';

      // Act
      controller.signIn(email, password);

      // Assert
      verify(() => mockAuthNotifier.signIn(email, password)).called(1);
    });

    test('watchAuthState calls watch on authNotifierProvider', () {
      final asyncUser = AsyncValue<User?>.data(null);

      when(() => mockRef.watch(authNotifierProvider))
          .thenReturn(asyncUser);

      final controller = AuthController(mockRef);

      final result = controller.watchAuthState();

      expect(result, asyncUser);
    });

    test('circleAvatarDef returns a CircleAvatar with correct properties', () {
      final controller = AuthController(mockRef);

      final avatar = controller.circleAvatarDef();

      expect(avatar, isA<CircleAvatar>());
      expect((avatar.backgroundImage as AssetImage).assetName, ImagePath.logo);
      expect(avatar.backgroundColor, yellow);
      expect(avatar.radius, AppSizes.circleLogoSize - 40);
    });

    testWidgets('authStateLoadingCheck returns CircularProgressIndicator when loading', (tester) async {
      final controller = AuthController(mockRef);
      final loadingState = AsyncValue<User?>.loading();

      final widget = controller.authStateLoadingCheck(loadingState);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final progress = tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator));
      expect(progress.color, white);
    });

    testWidgets('authStateLoadingCheck returns Text with signIn text when not loading', (tester) async {
      final controller = AuthController(mockRef);
      final dataState = AsyncValue<User?>.data(null);

      final widget = controller.authStateLoadingCheck(dataState);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.text(CustomText.signIn), findsOneWidget);
    });
  });
}
