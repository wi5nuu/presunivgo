import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/club_entities.dart';
import '../../domain/repositories/club_repository.dart';
import '../../data/repositories/club_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'club_provider.g.dart';

@Riverpod(keepAlive: true)
ClubRepository clubRepository(ClubRepositoryRef ref) {
  return ClubRepositoryImpl(FirebaseFirestore.instance);
}

@riverpod
Stream<List<ClubEntity>> clubList(ClubListRef ref) {
  return ref.watch(clubRepositoryProvider).getClubs();
}

@riverpod
Stream<List<ChannelEntity>> channelList(ChannelListRef ref, String clubId) {
  return ref.watch(clubRepositoryProvider).getChannels(clubId);
}

@riverpod
class ClubController extends _$ClubController {
  @override
  FutureOr<void> build() {}

  Future<void> createClub({
    required String name,
    required String description,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final clubId = DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseFirestore.instance.collection('clubs').doc(clubId).set({
        'club_id': clubId,
        'name': name,
        'description': description,
        'owner_uid': user.uid,
        'moderator_uids': [user.uid],
        'member_uids': [user.uid],
        'channel_ids': [],
        'is_verified': false,
        'created_at': FieldValue.serverTimestamp(),
        'icon_url': null,
        'banner_url': null,
      });
      // Create a default general channel
      final channelId = '${clubId}_general';
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .collection('channels')
          .doc(channelId)
          .set({
        'channel_id': channelId,
        'club_id': clubId,
        'name': 'general',
        'type': 'text',
        'is_private': false,
      });
    });
  }

  Future<void> joinClub(String clubId) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('clubs').doc(clubId).update({
      'member_uids': FieldValue.arrayUnion([user.uid]),
    });
  }
}
