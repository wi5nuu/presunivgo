import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<firebase_auth.User?> get authStateChanges;
  Future<firebase_auth.UserCredential> signIn(String email, String password);
  Future<firebase_auth.UserCredential> signUp(String email, String password);
  Future<void> signOut();
  Future<firebase_auth.UserCredential> signInWithGoogle();
  Future<void> sendEmailVerification();
  Future<void> reloadUser();
  firebase_auth.User? get currentUser;
  Future<UserModel?> getUserData(String uid);
  Future<void> saveUserData(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  @override
  Future<firebase_auth.UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<firebase_auth.UserCredential> signUp(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<firebase_auth.UserCredential> signInWithGoogle() async {
    // Use Firebase Auth's built-in popup — works natively on Flutter Web
    // without requiring the google_sign_in plugin.
    final provider = firebase_auth.GoogleAuthProvider();
    provider.addScope('email');
    provider.addScope('profile');
    return _firebaseAuth.signInWithPopup(provider);
  }

  @override
  Future<void> sendEmailVerification() =>
      _firebaseAuth.currentUser?.sendEmailVerification() ?? Future.value();

  @override
  Future<void> reloadUser() =>
      _firebaseAuth.currentUser?.reload() ?? Future.value();

  @override
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> saveUserData(UserModel user) {
    return _firestore.collection('users').doc(user.uid).set(user.toJson());
  }
}
