import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/chat_entity.dart';
import '../providers/chat_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../shared/widgets/pu_avatar.dart';
import '../../../../shared/widgets/typing_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _typingTimer;

  void _onTextChanged() {
    ref.read(chatControllerProvider.notifier).setTyping(widget.chatId, true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      ref.read(chatControllerProvider.notifier).setTyping(widget.chatId, false);
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    ref.read(chatControllerProvider.notifier).setTyping(widget.chatId, false);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(chatListProvider);
    final messagesState = ref.watch(messageStreamProvider(widget.chatId));
    final currentUser = ref.watch(authStateProvider).value;

    String? otherParticipantUid;
    chatList.whenData((chats) {
      try {
        final chat = chats.firstWhere((c) => c.chatId == widget.chatId);
        otherParticipantUid = chat.participants.firstWhere(
          (uid) => uid != currentUser?.uid,
          orElse: () => '',
        );
      } catch (_) {}
    });

    final otherUserProfile =
        otherParticipantUid != null && otherParticipantUid!.isNotEmpty
            ? ref.watch(userProfileProvider(otherParticipantUid!))
            : const AsyncValue<dynamic>.loading();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: otherUserProfile.when(
          data: (user) => Row(
            children: [
              PUAvatar(
                radius: 18,
                imageUrl: user?.profileImageUrl,
                initials: user?.name.isNotEmpty == true ? user!.name[0] : '?',
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.name ?? 'User',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  Text(user?.activityStatus.name ?? 'Offline',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textHint)),
                ],
              ),
            ],
          ),
          loading: () =>
              const Text('Loading...', style: TextStyle(fontSize: 15)),
          error: (_, __) => const Text('Chat', style: TextStyle(fontSize: 15)),
        ),
        actions: [
          IconButton(
              icon:
                  const Icon(Icons.videocam_outlined, color: AppColors.primary),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.call_outlined, color: AppColors.primary),
              onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesState.when(
              data: (messages) {
                // Mark messages as read when they arrive
                if (messages.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .read(chatControllerProvider.notifier)
                        .markAsRead(widget.chatId);
                  });
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderUid == currentUser?.uid;
                    return _MessageBubble(
                      isMe: isMe,
                      message: message,
                      otherUid: otherParticipantUid ?? '',
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, __) => Center(child: Text('Error: $err')),
            ),
          ),
          // Typing indicator
          Consumer(
            builder: (_, ref, __) {
              final typingAsync = ref.watch(typingUsersProvider(widget.chatId));
              final typing = typingAsync.valueOrNull ?? [];
              return typing.isNotEmpty
                  ? const TypingIndicator()
                  : const SizedBox.shrink();
            },
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _messageController,
                onChanged: (_) => _onTextChanged(),
                onSubmitted: (_) => _handleSend(),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    ref.read(chatControllerProvider.notifier).sendMessage(widget.chatId, text);
    _messageController.clear();
  }
}

class _MessageBubble extends StatelessWidget {
  final bool isMe;
  final MessageEntity message;
  final String otherUid;

  const _MessageBubble({
    required this.isMe,
    required this.message,
    required this.otherUid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
                boxShadow: [
                  if (!isMe)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                    color: isMe ? Colors.white : AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.4),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeago.format(message.timestamp, locale: 'en_short'),
                  style:
                      const TextStyle(fontSize: 10, color: AppColors.textHint),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    final isRead = message.readBy.contains(otherUid);
    // Simulate delivered if the message is in deliveredTo or we assume it's reached the server
    final isDelivered = message.deliveredTo.contains(otherUid) || true;

    if (isRead) {
      return const Icon(Icons.done_all,
          size: 14, color: Color(0xFF9C27B0)); // Purple
    } else if (isDelivered) {
      return const Icon(Icons.done_all,
          size: 14, color: AppColors.textHint); // Gray x2
    } else {
      return const Icon(Icons.done,
          size: 14, color: AppColors.textHint); // Gray x1
    }
  }
}
