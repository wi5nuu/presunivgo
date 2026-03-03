import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl();

  @override
  firebase_auth.User? get currentUser => _remoteDataSource.currentUser;

  @override
  Stream<UserEntity?> get userStateChanges =>
      _remoteDataSource.authStateChanges.asyncMap((user) async {
        if (user == null) return null;
        return _remoteDataSource.getUserData(user.uid);
      });

  @override
  Future<UserEntity> signInWithGoogle() async {
    final credential = await _remoteDataSource.signInWithGoogle();
    final String uid = credential.user!.uid;

    // Check if user already exists in Firestore
    var userData = await _remoteDataSource.getUserData(uid);

    if (userData == null) {
      // Create new user entry if it doesn't exist
      userData = UserModel(
        uid: uid,
        name: credential.user!.displayName ?? 'User',
        email: credential.user!.email ?? '',
        role: UserRole.student, // Default role
        activityStatus: ActivityStatus.student,
        lastActive: DateTime.now(),
        createdAt: DateTime.now(),
      );
      await _remoteDataSource.saveUserData(userData);
    }

    return userData;
  }

  @override
  Future<UserEntity> signIn(
      {required String email, required String password}) async {
    final credential = await _remoteDataSource.signIn(email, password);
    final userData = await _remoteDataSource.getUserData(credential.user!.uid);
    if (userData == null) throw Exception('User data not found');
    return userData;
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required ActivityStatus activityStatus,
    String? major,
    String? faculty,
    String? currentCompany,
  }) async {
    final credential = await _remoteDataSource.signUp(email, password);
    await credential.user?.updateDisplayName(name);

    final userModel = UserModel(
      uid: credential.user!.uid,
      name: name,
      email: email,
      role: role,
      activityStatus: activityStatus,
      major: major,
      faculty: faculty,
      currentCompany: currentCompany,
      lastActive: DateTime.now(),
      createdAt: DateTime.now(),
    );

    await _remoteDataSource.saveUserData(userModel);

    // Explicitly check current user context for verification
    final currentUser = _remoteDataSource.currentUser;
    if (currentUser != null) {
      await _remoteDataSource.sendEmailVerification();
    }
  }

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<void> sendEmailVerification() =>
      _remoteDataSource.sendEmailVerification();

  @override
  Future<bool> isEmailVerified() async {
    await _remoteDataSource.reloadUser();
    return _remoteDataSource.currentUser?.emailVerified ?? false;
  }
}
