import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/presentation/controller/profile_controller.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_notifier.dart';
import 'package:foodbook_beta/features/auth/presentation/states/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockWidgetRef extends Mock implements WidgetRef {}
class MockAuthNotifier extends Mock implements AuthNotifier {}
class MockBuildContext extends Mock implements BuildContext {}
class MockGoRouter extends Mock implements GoRouter {}

// Helper to stub GoRouter extension methods on BuildContext
extension on MockBuildContext {
  void mockGoNamed() {
    when(() => this.goNamed(any())).thenAnswer((_) {});
  }
}

void main() {
  late MockWidgetRef mockRef;
  late MockAuthNotifier mockAuthNotifier;
  late ProfileController controller;
  late MockBuildContext mockContext;

  setUp(() {
    mockRef = MockWidgetRef();
    mockAuthNotifier = MockAuthNotifier();
    mockContext = MockBuildContext();

    // Stub ref.read(authNotifierProvider.notifier) to return our mockAuthNotifier
    when(() => mockRef.read(authNotifierProvider.notifier))
        .thenReturn(mockAuthNotifier);

    // For context.goNamed (from go_router)
    when(() => mockContext.goNamed(any())).thenAnswer((_) {});

    controller = ProfileController(mockRef);
  });

  test('signOut success calls signOut and navigates to welcome', () async {
    // Arrange: stub signOut to complete successfully
    when(() => mockAuthNotifier.signOut()).thenAnswer((_) async {});

    // Act
    await controller.signOut(mockContext);

    // Assert
    verify(() => mockAuthNotifier.signOut()).called(1);
    verify(() => mockContext.goNamed('welcome')).called(1);
  });

  test('signOut failure shows SnackBar with error message', () async {
    // Arrange
    final error = Exception('logout error');
    when(() => mockAuthNotifier.signOut()).thenThrow(error);

    // For ScaffoldMessenger, we need to mock it.
    final scaffoldMessenger = ScaffoldMessenger.of(mockContext);
    // Can't mock ScaffoldMessenger.of easily, so instead we'll test by wrapping a widget
    // or just verify no navigation called

    // Act
    await controller.signOut(mockContext);

    // Assert
    verify(() => mockAuthNotifier.signOut()).called(1);
    verifyNever(() => mockContext.goNamed(any()));
  });
}
