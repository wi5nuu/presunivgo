import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});

final storiesStreamProvider = StreamProvider<List<StoryEntity>>((ref) {
  return ref.watch(storyRepositoryProvider).getStories();
});

class StoryController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  StoryController(this._ref) : super(const AsyncValue.data(null));

  Future<void> uploadStory(File imageFile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = _ref.read(authRepositoryProvider).currentUser;
      if (user == null) throw Exception('User not logged in');

      await _ref.read(storyRepositoryProvider).uploadStory(
            imageFile,
            user.uid,
            user.displayName ?? 'User',
            user.photoURL,
          );
    });
  }

  Future<void> markAsViewed(String storyId) async {
    final user = _ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await _ref
          .read(storyRepositoryProvider)
          .markStoryAsViewed(storyId, user.uid);
    }
  }
}

final storyControllerProvider =
    StateNotifierProvider<StoryController, AsyncValue<void>>((ref) {
  return StoryController(ref);
});
