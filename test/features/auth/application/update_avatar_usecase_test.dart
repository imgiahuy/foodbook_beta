import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/application/service/update_avatar_usecase.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late UpdateAvatarUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UpdateAvatarUseCase(mockRepository);
  });

  test('should call repository.updateAvatar()', () async {
    final file = File('dummy.png');

    when(() => mockRepository.updateAvatar(file)).thenAnswer((_) async {});

    await usecase(file);

    verify(() => mockRepository.updateAvatar(file)).called(1);
  });
}
