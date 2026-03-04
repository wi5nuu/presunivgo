import '../entities/story_entity.dart';

abstract class StoryRepository {
  Stream<List<StoryEntity>> getStories();
  Future<void> uploadStory(String imageUrl, String authorUid, String authorName,
      String? authorProfileImage);
  Future<void> deleteStory(String storyId);
  Future<void> markStoryAsViewed(String storyId, String userId);
}
