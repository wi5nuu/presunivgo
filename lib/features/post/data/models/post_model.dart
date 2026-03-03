import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.postId,
    required super.authorUid,
    required super.content,
    super.imageUrls,
    super.documentUrl,
    super.hashtags,
    super.mentions,
    super.reactions,
    super.commentsCount,
    super.sharesCount,
    required super.visibility,
    super.isPinned,
    required super.timestamp,
    super.editedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['post_id'] as String,
      authorUid: json['author_uid'] as String,
      content: json['content'] as String,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      documentUrl: json['document_url'] as String?,
      hashtags: List<String>.from(json['hashtags'] ?? []),
      mentions: List<String>.from(json['mentions'] ?? []),
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v)),
          ) ??
          {},
      commentsCount: json['comments_count'] as int? ?? 0,
      sharesCount: json['shares_count'] as int? ?? 0,
      visibility: json['visibility'] as String,
      isPinned: json['is_pinned'] as bool? ?? false,
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      editedAt: json['edited_at'] != null
          ? (json['edited_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'author_uid': authorUid,
      'content': content,
      'image_urls': imageUrls,
      'document_url': documentUrl,
      'hashtags': hashtags,
      'mentions': mentions,
      'reactions': reactions,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'visibility': visibility,
      'is_pinned': isPinned,
      'timestamp': FieldValue.serverTimestamp(),
      'edited_at': editedAt != null ? Timestamp.fromDate(editedAt!) : null,
    };
  }
}
