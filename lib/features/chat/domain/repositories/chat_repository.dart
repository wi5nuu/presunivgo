import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getChats(String userId);
  Stream<List<MessageEntity>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, MessageEntity message);
  Future<void> createChat(List<String> participants);
  Future<void> markAsRead(String chatId);
}
