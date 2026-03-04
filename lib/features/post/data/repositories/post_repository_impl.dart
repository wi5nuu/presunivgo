import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final FirebaseFirestore _firestore;

  PostRepositoryImpl(this._firestore);

  @override
  Stream<List<PostEntity>> getFeed({int limit = 10}) {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      final List<PostEntity> posts = [];
      for (final doc in snapshot.docs) {
        try {
          posts.add(PostModel.fromJson(doc.data()));
        } catch (e) {
          // Skip documents that fail to parse
        }
      }
      return posts;
    });
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final data = {
      'post_id': post.postId,
      'author_uid': post.authorUid,
      'content': post.content,
      'image_urls': post.imageUrls,
      'document_url': post.documentUrl,
      'hashtags': post.hashtags,
      'mentions': post.mentions,
      'reactions': post.reactions,
      'comments_count': 0,
      'shares_count': 0,
      'visibility': post.visibility,
      'is_pinned': false,
      'timestamp': FieldValue.serverTimestamp(),
      'edited_at': null,
    };
    await _firestore.collection('posts').doc(post.postId).set(data);
  }

  @override
  Future<void> reactToPost(
      String postId, String reactionType, String userId) async {
    await _firestore.collection('posts').doc(postId).update({
      'reactions.$reactionType': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }
}
