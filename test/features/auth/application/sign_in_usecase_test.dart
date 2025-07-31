import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_in_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}


void main() {
  late MockAuthRepository mockRepository;
  late SignInUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignInUsecase(mockRepository);
  });

  test('should return User on successful sign in', () async {
    final user = User(uid: '1', email: 'test@test.com', username: 'test');

    when(() => mockRepository.signIn('test@test.com', '1234'))
        .thenAnswer((_) async => user);

    final result = await usecase('test@test.com', '1234');

    expect(result, user);
    verify(() => mockRepository.signIn('test@test.com', '1234')).called(1);
  });

  test('should return null on failed sign in', () async {
    when(() => mockRepository.signIn('wrong@test.com', 'wrong'))
        .thenAnswer((_) async => null);

    final result = await usecase('wrong@test.com', 'wrong');

    expect(result, isNull);
  });
}
