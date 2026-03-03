import '../entities/club_entities.dart';

abstract class ClubRepository {
  Stream<List<ClubEntity>> getClubs();
  Stream<List<ChannelEntity>> getChannels(String clubId);
  Future<void> joinClub(String clubId, String uid);
  Future<void> leaveClub(String clubId, String uid);
  Future<void> sendMessage(String channelId, String content);
}
