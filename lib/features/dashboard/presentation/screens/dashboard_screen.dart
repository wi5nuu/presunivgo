import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.value;
    final profileAsync = currentUser != null
        ? ref.watch(userProfileProvider(currentUser.uid))
        : const AsyncValue<UserEntity?>.loading();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileAsync.when(
        data: (user) => _DashboardBody(user: user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load profile')),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final UserEntity? user;
  const _DashboardBody({required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'Student';
    final completion = user?.profileCompletion ?? 0.0;
    final connections = user?.connections.length ?? 0;
    final profileViews = user?.profileViews ?? 0;
    final isOpenToWork = user?.isOpenToWork ?? false;

    // Simulated 7-day activity (replace with real Firestore data later)
    const activityData = [3, 6, 2, 8, 5, 7, 4];
    final maxActivity = activityData.reduce((a, b) => a > b ? a : b);

    return CustomScrollView(
      slivers: [
        // Header
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, AppColors.primary],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good morning,',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                              Text(
                                name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (isOpenToWork)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.success.withOpacity(0.5)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.work_outline,
                                  color: AppColors.success, size: 13),
                              SizedBox(width: 4),
                              Text('Open to Work',
                                  style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Stats Row ─────────────────────────────────────────
              Row(
                children: [
                  _StatCard(
                    icon: Icons.visibility_outlined,
                    label: 'Profile Views',
                    value: profileViews.toString(),
                    subtitle: 'last 7 days',
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.people_outline,
                    label: 'Connections',
                    value: connections.toString(),
                    subtitle: 'network size',
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ApplicationsStatCard(),
              const SizedBox(height: 20),

              // ── Profile Strength ──────────────────────────────────
              _SectionHeader(title: 'Profile Strength'),
              const SizedBox(height: 12),
              _ProfileStrengthCard(completion: completion),
              const SizedBox(height: 20),

              // ── Activity Graph ────────────────────────────────────
              _SectionHeader(title: 'Activity (Last 7 Days)'),
              const SizedBox(height: 12),
              _ActivityGraph(data: activityData, maxValue: maxActivity),
              const SizedBox(height: 20),

              // ── Quick Actions ─────────────────────────────────────
              _SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              _QuickActionsGrid(context: context),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }
}

// ─── Subwidgets ──────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, color: color),
            ),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            Text(subtitle,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _ApplicationsStatCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateProvider).value;
    if (currentUser == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('applicant_uid', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final total = snapshot.data?.docs.length ?? 0;
        final pending = snapshot.data?.docs
                .where((d) => (d.data() as Map)['status'] == 'pending')
                .length ??
            0;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navy, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.send_outlined, color: Colors.white, size: 28),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Applications Sent',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text(
                    '$total total • $pending pending',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileStrengthCard extends StatelessWidget {
  final double completion;
  const _ProfileStrengthCard({required this.completion});

  @override
  Widget build(BuildContext context) {
    final pct = (completion * 100).round();
    final color = pct >= 80
        ? AppColors.success
        : pct >= 50
            ? AppColors.warning
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: completion.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: AppColors.border,
                  color: color,
                ),
                Text(
                  '$pct%',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Profile Completeness',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  pct >= 80
                      ? 'Your profile is looking great! 🚀'
                      : pct >= 50
                          ? 'Add more details to improve visibility'
                          : 'Complete your profile to get discovered',
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityGraph extends StatelessWidget {
  final List<int> data;
  final int maxValue;
  const _ActivityGraph({required this.data, required this.maxValue});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(data.length, (i) {
          final value = data[i];
          final heightFraction = maxValue == 0 ? 0.0 : value / maxValue;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    value.toString(),
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    height: 70 * heightFraction,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: i == 3
                            ? [AppColors.primary, AppColors.navy]
                            : [
                                AppColors.primary.withOpacity(0.3),
                                AppColors.primary.withOpacity(0.6)
                              ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _days[i],
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final BuildContext context;
  const _QuickActionsGrid({required this.context});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.psychology, 'AI Mentor', '/mentor-bot', AppColors.primary),
      (
        Icons.description_outlined,
        'CV Review',
        '/ai-cv-review',
        AppColors.royalBlue
      ),
      (
        Icons.map_outlined,
        'Career Map',
        '/ai-career-roadmap',
        AppColors.success
      ),
      (Icons.work_outline, 'Browse Jobs', '/jobs', AppColors.warning),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: actions.map((a) {
        return GestureDetector(
          onTap: () => context.push(a.$3),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: a.$4.withOpacity(0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: a.$4.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Icon(a.$1, color: a.$4, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    a.$2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: a.$4, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
