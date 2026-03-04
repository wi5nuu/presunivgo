import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/chat_entity.dart';
import '../providers/chat_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../shared/widgets/pu_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.value;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final chatsAsync = ref.watch(chatListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navy, AppColors.primary],
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Messages',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded,
                color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          Expanded(
            child: chatsAsync.when(
              data: (chats) {
                if (chats.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) => _ChatTile(
                    chat: chats[index],
                    currentUid: currentUser.uid,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => _buildEmptyState(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.background],
          stops: [0.0, 1.0],
        ),
      ),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search conversations...',
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.textHint),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 80, color: AppColors.textHint.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your conversations will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends ConsumerWidget {
  final ChatEntity chat;
  final String currentUid;

  const _ChatTile({required this.chat, required this.currentUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherUid = chat.participants
        .firstWhere((id) => id != currentUid, orElse: () => '');
    final otherUserProfile = ref.watch(userProfileProvider(otherUid));
    final unreadCount = chat.unreadCounts[currentUid] ?? 0;

    return otherUserProfile.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        return ListTile(
          onTap: () => context.push('/chat/${chat.chatId}'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: PUAvatar(
            radius: 28,
            imageUrl: user.profileImageUrl,
            initials: user.name.isNotEmpty ? user.name[0] : '?',
          ),
          title: Text(
            user.name,
            style: TextStyle(
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: unreadCount > 0
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeago.format(chat.lastMessageTime, locale: 'en_short'),
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
              const SizedBox(height: 6),
              if (unreadCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const ListTile(
        leading:
            CircleAvatar(radius: 28, backgroundColor: AppColors.surfaceVariant),
        title: SizedBox(width: 100, height: 16),
        subtitle: SizedBox(width: 200, height: 12),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
