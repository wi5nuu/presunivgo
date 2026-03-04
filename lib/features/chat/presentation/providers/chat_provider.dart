import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'chat_provider.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepositoryImpl(FirebaseFirestore.instance);
}

@riverpod
Stream<List<ChatEntity>> chatList(ChatListRef ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(chatRepositoryProvider).getChats(user.uid);
}

@riverpod
Stream<List<MessageEntity>> messageStream(MessageStreamRef ref, String chatId) {
  return ref.watch(chatRepositoryProvider).getMessages(chatId);
}

@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<void> build() {}

  Future<void> sendMessage(String chatId, String content) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    // Clear typing indicator when message is sent
    await setTyping(chatId, false);

    final message = MessageEntity(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      senderUid: user.uid,
      content: content,
      type: 'text',
      timestamp: DateTime.now(),
    );

    await ref.read(chatRepositoryProvider).sendMessage(chatId, message);
  }

  /// Toggle the typing indicator for the current user in a given chat.
  Future<void> setTyping(String chatId, bool isTyping) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;
    final doc = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('typing')
        .doc(user.uid);
    if (isTyping) {
      await doc.set({'uid': user.uid, 'at': FieldValue.serverTimestamp()});
    } else {
      await doc.delete();
    }
  }
}

/// Stream of UIDs currently typing in [chatId] (excluding self).
final typingUsersProvider =
    StreamProvider.family<List<String>, String>((ref, chatId) {
  final currentUid = ref.watch(authStateProvider).value?.uid;
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('typing')
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => d['uid'] as String)
          .where((uid) => uid != currentUid)
          .toList());
});
