import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/application/service/update_username.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late UpdateUserNameUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UpdateUserNameUseCase(mockRepository);
  });

  test('should call repository.updateUsername()', () async {
    when(() => mockRepository.updateUsername('newUser')).thenAnswer((_) async {});

    await usecase('newUser');

    verify(() => mockRepository.updateUsername('newUser')).called(1);
  });
}
