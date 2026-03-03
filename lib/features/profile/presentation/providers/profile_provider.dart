import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/repositories/profile_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepositoryImpl(FirebaseFirestore.instance);
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserEntity?> build() {
    return ref.watch(authStateProvider).value;
  }

  Future<void> updateProfile(UserEntity user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateProfile(user);
      return user;
    });
  }
}

@riverpod
Future<UserEntity?> userProfile(UserProfileRef ref, String uid) {
  return ref.watch(profileRepositoryProvider).getProfile(uid);
}
