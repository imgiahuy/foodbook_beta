import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_up_usecase.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late SignUpUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignUpUsecase(mockRepository);
  });

  test('should return User on successful sign up', () async {
    final user = User(uid: '1', email: 'new@test.com', username: 'new');
    when(() => mockRepository.signUp('new@test.com', '1234', 'new', any()))
        .thenAnswer((_) async => user);

    final result = await usecase('new@test.com', '1234', 'new');

    expect(result, user);
    verify(() => mockRepository.signUp('new@test.com', '1234', 'new', any())).called(1);
  });

  test('should return null on failed sign up', () async {
    when(() => mockRepository.signUp(any(), any(), any(), any()))
        .thenAnswer((_) async => null);

    final result = await usecase('fail@test.com', '1234', 'fail');

    expect(result, isNull);
  });
}
