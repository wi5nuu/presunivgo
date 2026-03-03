import 'package:cloud_firestore/cloud_firestore.dart';

class StoryEntity {
  final String id;
  final String authorUid;
  final String authorName;
  final String? authorProfileImage;
  final String imageUrl;
  final DateTime createdAt;
  final List<String> viewers;

  StoryEntity({
    required this.id,
    required this.authorUid,
    required this.authorName,
    this.authorProfileImage,
    required this.imageUrl,
    required this.createdAt,
    this.viewers = const [],
  });
}

class StoryModel extends StoryEntity {
  StoryModel({
    required super.id,
    required super.authorUid,
    required super.authorName,
    super.authorProfileImage,
    required super.imageUrl,
    required super.createdAt,
    super.viewers,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      authorUid: json['author_uid'] as String,
      authorName: json['author_name'] as String,
      authorProfileImage: json['author_profile_image'] as String?,
      imageUrl: json['image_url'] as String,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      viewers: List<String>.from(json['viewers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_uid': authorUid,
      'author_name': authorName,
      'author_profile_image': authorProfileImage,
      'image_url': imageUrl,
      'created_at': Timestamp.fromDate(createdAt),
      'viewers': viewers,
    };
  }
}
