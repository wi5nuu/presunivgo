import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepositoryImpl(this._firestore);

  @override
  Stream<List<ChatEntity>> getChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('last_message_time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> sendMessage(String chatId, MessageEntity message) async {
    final messageModel = MessageModel(
      messageId: message.messageId,
      senderUid: message.senderUid,
      content: message.content,
      type: message.type,
      timestamp: message.timestamp,
      readBy: message.readBy,
      deliveredTo: message.deliveredTo,
    );

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageModel.toJson());

    await _firestore.collection('chats').doc(chatId).update({
      'last_message': message.content,
      'last_message_time': Timestamp.fromDate(message.timestamp),
    });
  }

  @override
  Future<void> createChat(List<String> participants) async {
    final chatId = _firestore.collection('chats').doc().id;
    final chat = ChatModel(
      chatId: chatId,
      participants: participants,
      lastMessage: '',
      lastMessageTime: DateTime.now(),
      unreadCounts: {},
    );
    await _firestore.collection('chats').doc(chatId).set(chat.toJson());
  }

  @override
  Future<void> markAsRead(String chatId, String userId) async {
    final batch = _firestore.batch();

    // 1. Clear unread count
    batch.update(_firestore.collection('chats').doc(chatId), {
      'unread_counts.$userId': 0,
    });

    // 2. Mark all messages from others as read by me
    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('sender_uid', isNotEqualTo: userId)
        .get();

    for (var doc in messages.docs) {
      if (!(List<String>.from(doc.data()['read_by'] ?? []).contains(userId))) {
        batch.update(doc.reference, {
          'read_by': FieldValue.arrayUnion([userId])
        });
      }
    }

    await batch.commit();
  }
}
