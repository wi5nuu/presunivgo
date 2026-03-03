import '../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;
  VerifyEmailUseCase(this.repository);

  Future<void> call() {
    return repository.sendEmailVerification();
  }
}
