import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/repositories/profile_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/upload_service.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepositoryImpl(FirebaseFirestore.instance);
}

@riverpod
Stream<UserEntity?> userProfileStream(UserProfileStreamRef ref) {
  final auth = ref.watch(authStateProvider).value;
  if (auth == null) return Stream.value(null);
  return ref.watch(profileRepositoryProvider).getUserStream(auth.uid);
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserEntity?> build() {
    return ref.watch(userProfileStreamProvider).value;
  }

  Future<void> updateProfile(UserEntity user) async {
    // Only set loading if needed, or rely on AsyncValue.guard
    await ref.read(profileRepositoryProvider).updateProfile(user);
    // No need to manually update state as we are watching the stream
  }
}

@riverpod
Future<UserEntity?> userProfile(UserProfileRef ref, String uid) {
  return ref.watch(profileRepositoryProvider).getProfile(uid);
}
