class ClubEntity {
  final String clubId;
  final String name;
  final String description;
  final String? iconUrl;
  final String? bannerUrl;
  final String ownerUid;
  final List<String> moderatorUids;
  final List<String> memberUids;
  final List<String> channelIds;
  final bool isVerified;
  final DateTime createdAt;

  ClubEntity({
    required this.clubId,
    required this.name,
    required this.description,
    this.iconUrl,
    this.bannerUrl,
    required this.ownerUid,
    this.moderatorUids = const [],
    this.memberUids = const [],
    this.channelIds = const [],
    this.isVerified = false,
    required this.createdAt,
  });
}

class ChannelEntity {
  final String channelId;
  final String clubId;
  final String name;
  final String type; // text | voice | announcements
  final bool isPrivate;

  ChannelEntity({
    required this.channelId,
    required this.clubId,
    required this.name,
    required this.type,
    this.isPrivate = false,
  });
}
