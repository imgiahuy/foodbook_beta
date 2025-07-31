import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/posten/presentation/controller/post_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodbook_beta/features/posten/domain/model/post_repository.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';

// Mock classes
class MockPostRepository extends Mock implements PostRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockPostRepository mockPostRepo;
  late MockAuthRepository mockAuthRepo;
  late PostController controller;

  setUp(() {
    mockPostRepo = MockPostRepository();
    mockAuthRepo = MockAuthRepository();
    controller = PostController(mockPostRepo, mockAuthRepo);
  });

  test('pickImage sets image and notifies listeners', () async {

    final testImageFile = File('test_path.jpg');

    controller.image = testImageFile;

    bool notified = false;
    controller.addListener(() {
      notified = true;
    });

    controller.notifyListeners();

    expect(controller.image, testImageFile);
    expect(notified, isTrue);
  });
}
