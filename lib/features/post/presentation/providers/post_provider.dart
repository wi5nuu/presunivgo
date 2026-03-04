import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/upload_service.dart';

part 'post_provider.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepositoryImpl(FirebaseFirestore.instance);
}

final feedLimitProvider = StateProvider<int>((ref) => 10);

@riverpod
Stream<List<PostEntity>> feed(FeedRef ref) {
  final limit = ref.watch(feedLimitProvider);
  return ref.watch(postRepositoryProvider).getFeed(limit: limit);
}

@riverpod
class PostController extends _$PostController {
  @override
  FutureOr<void> build() {}

  Future<void> createPost(
      String content, List<String> imageUrls, String visibility) async {
    final userState = ref.read(authStateProvider);
    final user = userState.value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final post = PostEntity(
        postId: DateTime.now().millisecondsSinceEpoch.toString(),
        authorUid: user.uid,
        content: content,
        imageUrls: imageUrls,
        timestamp: DateTime.now(),
        visibility: visibility,
      );
      await ref.read(postRepositoryProvider).createPost(post);
    });
  }

  Future<String> uploadMedia(File file) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) throw Exception('User not logged in');

    final path =
        'posts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await ref.read(uploadServiceProvider).uploadFile(
          file: file,
          path: path,
        );
  }

  Future<void> reactToPost(String postId, String reactionType) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;
    await ref
        .read(postRepositoryProvider)
        .reactToPost(postId, reactionType, user.uid);
  }

  Future<void> addComment(String postId, String content) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'comment_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'author_uid': user.uid,
      'author_name': user.name,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'comments_count': FieldValue.increment(1),
    });
  }
}
