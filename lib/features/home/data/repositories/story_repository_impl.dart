import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  final FirebaseFirestore _firestore;

  StoryRepositoryImpl(this._firestore, _);

  @override
  Stream<List<StoryEntity>> getStories() {
    // Stories older than 24 hours should be filtered out
    final yesterday = DateTime.now().subtract(const Duration(hours: 24));
    return _firestore
        .collection('stories')
        .where('created_at', isGreaterThan: Timestamp.fromDate(yesterday))
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StoryModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> uploadStory(String imageUrl, String authorUid, String authorName,
      String? authorProfileImage) async {
    final storyId = const Uuid().v4();

    final story = StoryModel(
      id: storyId,
      authorUid: authorUid,
      authorName: authorName,
      authorProfileImage: authorProfileImage,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      viewers: [],
    );

    await _firestore.collection('stories').doc(storyId).set(story.toJson());
  }

  @override
  Future<void> deleteStory(String storyId) async {
    await _firestore.collection('stories').doc(storyId).delete();
  }

  @override
  Future<void> markStoryAsViewed(String storyId, String userId) async {
    await _firestore.collection('stories').doc(storyId).update({
      'viewers': FieldValue.arrayUnion([userId]),
    });
  }
}
