class ChatEntity {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final Map<String, int> unreadCounts;
  final bool isGroup;
  final String? groupName;
  final String? groupIconUrl;

  ChatEntity({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCounts,
    this.isGroup = false,
    this.groupName,
    this.groupIconUrl,
  });
}

class MessageEntity {
  final String messageId;
  final String senderUid;
  final String content;
  final String type; // text | image | audio | document
  final String? attachmentUrl;
  final DateTime timestamp;
  final List<String> readBy;
  final List<String> deliveredTo;

  MessageEntity({
    required this.messageId,
    required this.senderUid,
    required this.content,
    required this.type,
    this.attachmentUrl,
    required this.timestamp,
    this.readBy = const [],
    this.deliveredTo = const [],
  });
}
