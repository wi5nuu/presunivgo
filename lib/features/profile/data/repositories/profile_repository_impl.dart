import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity?> getProfile(String uid);
  Stream<UserEntity?> getUserStream(String uid);
  Future<void> updateProfile(UserEntity user);
  Future<List<UserEntity>> searchAlumni(String query);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepositoryImpl(this._firestore);

  @override
  Future<UserEntity?> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Stream<UserEntity?> getUserStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null);
  }

  @override
  Future<void> updateProfile(UserEntity user) async {
    final model = user is UserModel
        ? user
        : UserModel(
            uid: user.uid,
            name: user.name,
            email: user.email,
            role: user.role,
            major: user.major,
            faculty: user.faculty,
            batch: user.batch,
            nimOrEid: user.nimOrEid,
            headline: user.headline,
            bio: user.bio,
            location: user.location,
            profileImageUrl: user.profileImageUrl,
            bannerImageUrl: user.bannerImageUrl,
            isVerified: user.isVerified,
            isOpenToWork: user.isOpenToWork,
            skills: user.skills,
            connections: user.connections,
            followers: user.followers,
            following: user.following,
            experience: user.experience,
            education: user.education,
            projects: user.projects,
            certifications: user.certifications,
            profileCompletion: user.profileCompletion,
            profileViews: user.profileViews,
            activityStatus: user.activityStatus,
            currentCompany: user.currentCompany,
            lastActive: user.lastActive,
            createdAt: user.createdAt,
            fcmToken: user.fcmToken,
            settings: user.settings,
          );
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(model.toJson(), SetOptions(merge: true));
  }

  @override
  Future<List<UserEntity>> searchAlumni(String query) async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'alumni')
        // Simple client-side filtering for demonstration, Algolia would be better
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .where((u) => u.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
