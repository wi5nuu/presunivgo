import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
// import '../../data/repositories/mock_auth_repository.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl();
}

@riverpod
Stream<UserEntity?> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).userStateChanges;
}

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    });
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required ActivityStatus activityStatus,
    String? major,
    String? faculty,
    String? currentCompany,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUp(
            name: name,
            email: email,
            password: password,
            role: role,
            activityStatus: activityStatus,
            major: major,
            faculty: faculty,
            currentCompany: currentCompany,
          );
    });
  }

  Future<void> resendVerification() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendEmailVerification();
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
