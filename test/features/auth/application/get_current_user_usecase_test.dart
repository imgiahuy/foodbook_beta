import 'package:foodbook_beta/features/auth/application/service/get_current_user_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/domain/models/user.dart';
class MockAuthRepository extends Mock implements AuthRepository {}


void main() {
  late MockAuthRepository mockRepository;
  late GetCurrentUserUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetCurrentUserUsecase(mockRepository);
  });

  test('should return User when user is signed in', () async {
    final user = User(uid: '1', email: 'test@test.com', username: 'test');
    when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => user);

    final result = await usecase();

    expect(result, user);
    verify(() => mockRepository.getCurrentUser()).called(1);
  });

  test('should return null when no user is signed in', () async {
    when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => null);

    final result = await usecase();

    expect(result, isNull);
  });
}
