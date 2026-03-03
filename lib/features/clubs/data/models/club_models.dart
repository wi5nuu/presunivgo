import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/club_entities.dart';

class ClubModel extends ClubEntity {
  ClubModel({
    required super.clubId,
    required super.name,
    required super.description,
    super.iconUrl,
    super.bannerUrl,
    required super.ownerUid,
    super.moderatorUids,
    super.memberUids,
    super.channelIds,
    super.isVerified,
    required super.createdAt,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      clubId: json['club_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      ownerUid: json['owner_uid'] as String,
      moderatorUids: List<String>.from(json['moderator_uids'] ?? []),
      memberUids: List<String>.from(json['member_uids'] ?? []),
      channelIds: List<String>.from(json['channel_ids'] ?? []),
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'club_id': clubId,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'banner_url': bannerUrl,
      'owner_uid': ownerUid,
      'moderator_uids': moderatorUids,
      'member_uids': memberUids,
      'channel_ids': channelIds,
      'is_verified': isVerified,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}

class ChannelModel extends ChannelEntity {
  ChannelModel({
    required super.channelId,
    required super.clubId,
    required super.name,
    required super.type,
    super.isPrivate,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      channelId: json['channel_id'] as String,
      clubId: json['club_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      isPrivate: json['is_private'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'club_id': clubId,
      'name': name,
      'type': type,
      'is_private': isPrivate,
    };
  }
}
