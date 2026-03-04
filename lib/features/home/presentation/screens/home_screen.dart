import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../post/presentation/widgets/post_card.dart';
import '../widgets/story_bar.dart';
import '../../../post/presentation/widgets/create_post_modal.dart';
import '../../../post/presentation/providers/post_provider.dart';
import '../../../../shared/widgets/pu_shimmer.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../shared/widgets/pu_avatar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedProvider);
    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Premium Header with Search
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                PUAvatar(
                  radius: 18,
                  imageUrl: user?.profileImageUrl,
                  initials: user?.name.isNotEmpty == true ? user!.name[0] : '?',
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search,
                              color: AppColors.textSecondary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Search campus...',
                            style: TextStyle(
                              color: AppColors.textHint,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white),
                  onPressed: () => context.push('/chat'),
                ),
              ],
            ),
          ),

          // Story Bar
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: StoryBar(),
            ),
          ),

          // Create Post Placeholder
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: GestureDetector(
                onTap: () => _showCreatePost(context),
                child: CreatePostPlaceholder(user: user),
              ),
            ),
          ),

          // Feed
          feedState.when(
            data: (posts) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: PostCard(post: posts[index])
                        .animate()
                        .fadeIn(delay: (index * 50).ms)
                        .scale(
                            begin: const Offset(0.95, 0.95),
                            curve: Curves.easeOutQuad),
                  );
                },
                childCount: posts.length,
              ),
            ),
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: PUShimmer.card(),
                ),
                childCount: 5,
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error loading feed: $err')),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePost(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
    );
  }

  void _showCreatePost(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: const CreatePostModal(),
      ),
    );
  }
}

class CreatePostPlaceholder extends StatelessWidget {
  final dynamic user;
  const CreatePostPlaceholder({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          PUAvatar(
            radius: 20,
            imageUrl: user?.profileImageUrl,
            initials: user?.name.isNotEmpty == true ? user!.name[0] : '?',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                "Share something with the campus...",
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.image_outlined,
              color: AppColors.secondary, size: 22),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}
