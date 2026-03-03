import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'post_provider.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepositoryImpl(FirebaseFirestore.instance);
}

@riverpod
Stream<List<PostEntity>> feed(FeedRef ref) {
  return ref.watch(postRepositoryProvider).getFeed();
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
