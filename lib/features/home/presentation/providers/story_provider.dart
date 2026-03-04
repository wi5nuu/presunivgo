import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/upload_service.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
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

  Future<void> uploadStory(File imageFile) async {
    final user = _ref.read(authStateProvider).value;
    if (user == null) return;

    state =
        state.copyWith(uploadStatus: const AsyncValue.loading(), progress: 0.0);

    try {
      final path =
          'stories/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Use uploadFileWithProgress to track progress
      final progressStream =
          _ref.read(uploadServiceProvider).uploadFileWithProgress(
                file: imageFile,
                path: path,
              );

      await for (final progress in progressStream) {
        state = state.copyWith(progress: progress);
      }

      // Once finished, get the URL and update Firestore
      final url = await _ref.read(uploadServiceProvider).uploadFile(
            file: imageFile,
            path: path,
          );

      await _ref.read(storyRepositoryProvider).uploadStory(
            url,
            user.uid,
            user.name,
            user.profileImageUrl,
          );

      state = state.copyWith(
          uploadStatus: const AsyncValue.data(null), progress: 1.0);
    } catch (e, st) {
      state = state.copyWith(uploadStatus: AsyncValue.error(e, st));
    }
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
