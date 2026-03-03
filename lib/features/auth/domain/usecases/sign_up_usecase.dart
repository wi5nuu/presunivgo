import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required ActivityStatus activityStatus,
    String? currentCompany,
  }) {
    return repository.signUp(
      name: name,
      email: email,
      password: password,
      role: role,
      activityStatus: activityStatus,
      currentCompany: currentCompany,
    );
  }
}
