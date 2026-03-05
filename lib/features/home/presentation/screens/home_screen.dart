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
import '../../../../shared/widgets/glass_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(feedLimitProvider.notifier).state += 10;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);
    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Premium Header with Search
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            automaticallyImplyLeading: false,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.zoomBackground
              ],
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.navy,
                      AppColors.primary,
                      AppColors.secondary
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: Row(
              children: [
                Hero(
                  tag: 'profile_avatar',
                  child: PUAvatar(
                    radius: 20,
                    imageUrl: user?.profileImageUrl,
                    initials:
                        user?.name.isNotEmpty == true ? user!.name[0] : '?',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search_rounded,
                              color: Colors.white70, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Search campus...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: Colors.white),
                  onPressed: () {},
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
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
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
    return GlassContainer(
      blur: 15,
      opacity: 0.7,
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: AppColors.cyberMagenta.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ],
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
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}
