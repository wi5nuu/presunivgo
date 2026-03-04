import '../entities/post_entity.dart';

abstract class PostRepository {
  Stream<List<PostEntity>> getFeed({int limit = 10});
  Future<void> createPost(PostEntity post);
  Future<void> reactToPost(String postId, String reactionType, String userId);
  Future<void> deletePost(String postId);
}
