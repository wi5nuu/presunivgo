import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.chatId,
    required super.participants,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.unreadCounts,
    super.isGroup,
    super.groupName,
    super.groupIconUrl,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chat_id'] as String,
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['last_message'] as String,
      lastMessageTime: (json['last_message_time'] as Timestamp).toDate(),
      unreadCounts: Map<String, int>.from(json['unread_counts'] ?? {}),
      isGroup: json['is_group'] as bool? ?? false,
      groupName: json['group_name'] as String?,
      groupIconUrl: json['group_icon_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'participants': participants,
      'last_message': lastMessage,
      'last_message_time': Timestamp.fromDate(lastMessageTime),
      'unread_counts': unreadCounts,
      'is_group': isGroup,
      'group_name': groupName,
      'group_icon_url': groupIconUrl,
    };
  }
}

class MessageModel extends MessageEntity {
  MessageModel({
    required super.messageId,
    required super.senderUid,
    required super.content,
    required super.type,
    super.attachmentUrl,
    required super.timestamp,
    super.readBy,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'] as String,
      senderUid: json['sender_uid'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      readBy: List<String>.from(json['read_by'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'sender_uid': senderUid,
      'content': content,
      'type': type,
      'attachment_url': attachmentUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'read_by': readBy,
    };
  }
}
