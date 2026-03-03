class PostEntity {
  final String postId;
  final String authorUid;
  final String content;
  final List<String> imageUrls;
  final String? documentUrl;
  final List<String> hashtags;
  final List<String> mentions;
  final Map<String, List<String>> reactions;
  final int commentsCount;
  final int sharesCount;
  final String visibility;
  final bool isPinned;
  final DateTime timestamp;
  final DateTime? editedAt;

  PostEntity({
    required this.postId,
    required this.authorUid,
    required this.content,
    this.imageUrls = const [],
    this.documentUrl,
    this.hashtags = const [],
    this.mentions = const [],
    this.reactions = const {},
    this.commentsCount = 0,
    this.sharesCount = 0,
    required this.visibility,
    this.isPinned = false,
    required this.timestamp,
    this.editedAt,
  });
}
