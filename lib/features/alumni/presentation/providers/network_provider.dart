import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

final suggestedPeopleProvider =
    FutureProvider.autoDispose<List<UserEntity>>((ref) async {
  final currentUser = ref.watch(authStateProvider).value;
  if (currentUser == null) return [];

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('uid', isNotEqualTo: currentUser.uid)
      .limit(20)
      .get();

  final repo = ref.read(profileRepositoryProvider);
  final profiles = await Future.wait(
    snapshot.docs.map((doc) => repo.getProfile(doc.id)),
  );
  return profiles.whereType<UserEntity>().toList();
});

final myConnectionsProvider =
    FutureProvider.autoDispose<List<UserEntity>>((ref) async {
  final currentUser = ref.watch(authStateProvider).value;
  if (currentUser == null) return [];

  final myProfile =
      await ref.read(profileRepositoryProvider).getProfile(currentUser.uid);
  if (myProfile == null || myProfile.connections.isEmpty) return [];

  final results = await Future.wait(
    myProfile.connections
        .map((uid) => ref.read(profileRepositoryProvider).getProfile(uid)),
  );
  return results.whereType<UserEntity>().toList();
});
