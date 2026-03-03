import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/post_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../shared/widgets/pu_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shimmer/shimmer.dart';

class PostCard extends ConsumerWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorState = ref.watch(userProfileProvider(post.authorUid));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(authorState),
          _buildContent(),
          if (post.imageUrls.isNotEmpty) _buildImageGallery(),
          _buildActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildHeader(AsyncValue authorState) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          authorState.when(
            data: (user) => PUAvatar(
              radius: 20,
              imageUrl: user?.profileImageUrl,
              initials: user?.name.isNotEmpty == true ? user!.name[0] : '?',
            ),
            loading: () => Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[50]!,
              child: const CircleAvatar(radius: 20),
            ),
            error: (_, __) => const PUAvatar(radius: 20, initials: '?'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: authorState.when(
              data: (user) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary),
                  ),
                  Text(
                    '${user?.headline ?? user?.activityStatus.name ?? 'Member'} • ${timeago.format(post.timestamp)}',
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              loading: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 12, color: Colors.grey[200]),
                  const SizedBox(height: 4),
                  Container(width: 60, height: 10, color: Colors.grey[200]),
                ],
              ),
              error: (_, __) =>
                  const Text('Unknown user', style: TextStyle(fontSize: 14)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textHint),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        post.content,
        style: const TextStyle(
            fontSize: 15, color: AppColors.textPrimary, height: 1.4),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
      ),
      constraints: const BoxConstraints(maxHeight: 400),
      width: double.infinity,
      child: Image.network(
        post.imageUrls.first,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.image_not_supported_outlined,
                color: AppColors.textHint)),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateProvider).value;
    final isLiked = post.reactions['like']?.contains(currentUser?.uid) ?? false;
    final likesCount = post.reactions['like']?.length ?? 0;
    final commentsCount = post.commentsCount;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (likesCount > 0 || commentsCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                children: [
                  if (likesCount > 0) ...[
                    const Icon(Icons.thumb_up,
                        size: 12, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text('$likesCount',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textHint)),
                  ],
                  const Spacer(),
                  if (commentsCount > 0)
                    Text('$commentsCount comments',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: 'Like',
                color: isLiked ? AppColors.primary : AppColors.textSecondary,
                onTap: () => _likePost(ref),
              ),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: 'Comment',
                onTap: () => _showComments(context, ref),
              ),
              _ActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _likePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).reactToPost(post.postId, 'like');
  }

  void _showComments(BuildContext context, WidgetRef ref) {
    final commentCtrl = TextEditingController();
    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('Comments',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            Row(
              children: [
                PUAvatar(
                    radius: 20,
                    imageUrl: user?.profileImageUrl,
                    initials:
                        user?.name.isNotEmpty == true ? user!.name[0] : '?'),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: commentCtrl,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: () async {
                    if (commentCtrl.text.trim().isEmpty) return;
                    await ref
                        .read(postControllerProvider.notifier)
                        .addComment(post.postId, commentCtrl.text.trim());
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon,
      required this.label,
      this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: color ?? AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
