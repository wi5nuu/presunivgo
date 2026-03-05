import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(
    FirebaseFirestore.instance,
  );
});

final storiesStreamProvider = StreamProvider<List<StoryEntity>>((ref) {
  return ref.watch(storyRepositoryProvider).getStories();
});

class StoryState {
  final AsyncValue<void> uploadStatus;
  final double progress;

  StoryState({
    this.uploadStatus = const AsyncValue.data(null),
    this.progress = 0.0,
  });

  StoryState copyWith({
    AsyncValue<void>? uploadStatus,
    double? progress,
  }) {
    return StoryState(
      uploadStatus: uploadStatus ?? this.uploadStatus,
      progress: progress ?? this.progress,
    );
  }
}

class StoryController extends StateNotifier<StoryState> {
  final Ref _ref;

  StoryController(this._ref) : super(StoryState());

  Future<void> uploadStory(dynamic ignored) async {
    // Deprecated: We no longer use Firebase Storage for stories
  }

  Future<void> markAsViewed(String storyId) async {
    final user = _ref.read(authStateProvider).value;
    if (user != null) {
      await _ref
          .read(storyRepositoryProvider)
          .markStoryAsViewed(storyId, user.uid);
    }
  }
}

final storyControllerProvider =
    StateNotifierProvider<StoryController, StoryState>((ref) {
  return StoryController(ref);
});
