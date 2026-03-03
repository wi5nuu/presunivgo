import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get userStateChanges;
  firebase_auth.User? get currentUser;

  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required ActivityStatus activityStatus,
    String? major,
    String? faculty,
    String? currentCompany,
  });

  Future<void> signOut();
  Future<UserEntity> signInWithGoogle();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();
}
