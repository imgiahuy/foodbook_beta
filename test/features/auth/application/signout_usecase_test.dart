import 'package:flutter_test/flutter_test.dart';
import 'package:foodbook_beta/features/auth/application/service/sign_out_usecase.dart';
import 'package:foodbook_beta/features/auth/domain/models/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late SignOutUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignOutUsecase(mockRepository);
  });

  test('should call repository.signOut()', () async {
    when(() => mockRepository.signOut()).thenAnswer((_) async {});

    await usecase();

    verify(() => mockRepository.signOut()).called(1);
  });
}
