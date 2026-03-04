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
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/widgets/glass_container.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _isExpanded = false;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authorState = ref.watch(userProfileProvider(widget.post.authorUid));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        blur: 15,
        opacity: 0.7,
        color: Colors.white,
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyberMagenta.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(authorState, context),
            _buildContent(),
            if (widget.post.imageUrls.isNotEmpty) _buildImageGallery(),
            _buildActions(context),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutQuad),
    );
  }

  Widget _buildHeader(AsyncValue authorState, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          authorState.when(
            data: (user) => PUAvatar(
              radius: 24,
              imageUrl: user?.profileImageUrl,
              initials: user?.name.isNotEmpty == true ? user!.name[0] : '?',
            ),
            loading: () => Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[50]!,
                child: const CircleAvatar(radius: 24)),
            error: (_, __) => const PUAvatar(radius: 24, initials: '?'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: authorState.when(
              data: (user) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text('1st',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                  Text(
                    user?.headline ?? user?.activityStatus.name ?? 'Member',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    timeago.format(widget.post.timestamp),
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 11),
                  ),
                ],
              ),
              loading: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 12, color: Colors.grey[100]),
                  const SizedBox(height: 4),
                  Container(width: 60, height: 10, color: Colors.grey[100]),
                ],
              ),
              error: (_, __) =>
                  const Text('Unknown user', style: TextStyle(fontSize: 14)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textHint),
            onPressed: () => _showContextMenu(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: const Text('Save Post'),
                onTap: () => Navigator.pop(ctx)),
            ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy Link'),
                onTap: () => Navigator.pop(ctx)),
            ListTile(
                leading: const Icon(Icons.visibility_off_outlined),
                title: const Text('Hide Post'),
                onTap: () => Navigator.pop(ctx)),
            ListTile(
                leading:
                    const Icon(Icons.report_outlined, color: AppColors.error),
                title: const Text('Report Post',
                    style: TextStyle(color: AppColors.error)),
                onTap: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final content = widget.post.content;
    final isLong = content.length > 150;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isExpanded || !isLong
                ? content
                : '${content.substring(0, 150)}...',
            style: const TextStyle(
                fontSize: 14, color: AppColors.textPrimary, height: 1.5),
          ),
          if (isLong)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _isExpanded ? 'Show less' : 'See more',
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: AppColors.background, borderRadius: BorderRadius.circular(0)),
      constraints: const BoxConstraints(maxHeight: 350),
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.post.imageUrls.length,
            onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
            itemBuilder: (context, index) {
              return Image.network(
                widget.post.imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported_outlined,
                        color: AppColors.textHint)),
              );
            },
          ),
          if (widget.post.imageUrls.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.post.imageUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentImageIndex == index ? 8 : 6,
                    height: _currentImageIndex == index ? 8 : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? AppColors.primary
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final currentUser = ref.watch(authStateProvider).value;
    final isLiked =
        widget.post.reactions['like']?.contains(currentUser?.uid) ?? false;
    final likesCount = widget.post.reactions['like']?.length ?? 0;
    final commentsCount = widget.post.commentsCount;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (likesCount > 0 || commentsCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  if (likesCount > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.thumb_up,
                          size: 10, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text('$likesCount',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold)),
                  ],
                  const Spacer(),
                  if (commentsCount > 0)
                    Text('$commentsCount comments',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  const Text('· 4 shares',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                label: 'Like',
                color: isLiked ? AppColors.primary : AppColors.textSecondary,
                onTap: () => _likePost(),
              ),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: 'Comment',
                onTap: () => _showComments(context),
              ),
              _ActionButton(
                icon: Icons.repeat_rounded,
                label: 'Repost',
                onTap: () {},
              ),
              _ActionButton(
                icon: Icons.send_outlined,
                label: 'Send',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _likePost() {
    ref
        .read(postControllerProvider.notifier)
        .reactToPost(widget.post.postId, 'like');
  }

  void _showComments(BuildContext context) {
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
                    await ref.read(postControllerProvider.notifier).addComment(
                        widget.post.postId, commentCtrl.text.trim());
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
