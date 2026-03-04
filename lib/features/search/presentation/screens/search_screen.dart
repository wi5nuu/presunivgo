import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/pu_avatar.dart';
import '../providers/search_provider.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);

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
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchCtrl,
            autofocus: true,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Search people, jobs, posts...',
              hintStyle: TextStyle(color: Colors.white60),
              border: InputBorder.none,
              prefixIcon:
                  Icon(Icons.search_rounded, color: Colors.white70, size: 22),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'People'),
            Tab(text: 'Jobs'),
            Tab(text: 'Posts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PeopleTab(query: query),
          _JobsTab(query: query),
          _PostsTab(query: query),
        ],
      ),
    );
  }
}

// ─── People Tab ────────────────────────────────────────────────────────────────

class _PeopleTab extends ConsumerWidget {
  final String query;
  const _PeopleTab({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isEmpty) {
      return _EmptyPrompt(
          icon: Icons.person_search_outlined,
          label: 'Search for people by name');
    }
    final async = ref.watch(searchPeopleProvider(query));
    return async.when(
      data: (people) => people.isEmpty
          ? _EmptyResult(query: query)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: people.length,
              itemBuilder: (_, i) => _PersonTile(user: people[i]),
            ),
      loading: () => const _LoadingList(),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _PersonTile extends StatelessWidget {
  final UserEntity user;
  const _PersonTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: PUAvatar(
        radius: 24,
        imageUrl: user.profileImageUrl,
        initials: user.name.isNotEmpty ? user.name[0] : '?',
      ),
      title: Text(user.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      subtitle: Text(
        user.headline ?? user.major ?? user.role.name,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _RoleBadge(role: user.role),
    );
  }
}

// ─── Jobs Tab ─────────────────────────────────────────────────────────────────

class _JobsTab extends ConsumerWidget {
  final String query;
  const _JobsTab({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isEmpty) {
      return _EmptyPrompt(
          icon: Icons.work_outline, label: 'Search for job opportunities');
    }
    final async = ref.watch(searchJobsProvider(query));
    return async.when(
      data: (jobs) => jobs.isEmpty
          ? _EmptyResult(query: query)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: jobs.length,
              itemBuilder: (_, i) => _JobTile(job: jobs[i]),
            ),
      loading: () => const _LoadingList(),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _JobTile extends StatelessWidget {
  final JobEntity job;
  const _JobTile({required this.job});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.business, color: AppColors.primary),
      ),
      title: Text(job.title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      subtitle: Text(
        '${job.companyName} • ${job.location}',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(job.type,
            style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ─── Posts Tab ────────────────────────────────────────────────────────────────

class _PostsTab extends ConsumerWidget {
  final String query;
  const _PostsTab({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isEmpty) {
      return _EmptyPrompt(
          icon: Icons.article_outlined, label: 'Search for posts and updates');
    }
    final async = ref.watch(searchPostsProvider(query));
    return async.when(
      data: (posts) => posts.isEmpty
          ? _EmptyResult(query: query)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: posts.length,
              itemBuilder: (_, i) => _PostTile(post: posts[i]),
            ),
      loading: () => const _LoadingList(),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _PostTile extends StatelessWidget {
  final Map<String, dynamic> post;
  const _PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post['content'] ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.thumb_up_outlined,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text('${post['likes_count'] ?? 0}',
                  style:
                      const TextStyle(color: AppColors.textHint, fontSize: 12)),
              const SizedBox(width: 16),
              const Icon(Icons.comment_outlined,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text('${post['comments_count'] ?? 0}',
                  style:
                      const TextStyle(color: AppColors.textHint, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ────────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final UserRole role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      UserRole.student => AppColors.studentColor,
      UserRole.alumni => AppColors.alumniColor,
      UserRole.lecturer => AppColors.lecturerColor,
      UserRole.admin => AppColors.adminColor,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(role.name.toUpperCase(),
          style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EmptyPrompt({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: AppColors.textHint.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 15)),
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  final String query;
  const _EmptyResult({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 72, color: AppColors.textHint.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('No results for "$query"',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 15)),
        ],
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
