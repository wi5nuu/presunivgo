import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/pu_avatar.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/network_provider.dart';
import '../providers/connection_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class NetworkScreen extends ConsumerWidget {
  const NetworkScreen({super.key});

  Future<void> _connect(
      BuildContext context, WidgetRef ref, String targetUid) async {
    final controller = ref.read(connectionControllerProvider);
    await controller.sendRequest(targetUid);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection request sent! 🎉'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedAsync = ref.watch(suggestedPeopleProvider);
    final connectionsAsync = ref.watch(myConnectionsProvider);
    final requestsAsync = ref.watch(connectionRequestsProvider);
    final sentRequestsAsync = ref.watch(sentRequestsProvider);
    final currentUser = ref.watch(authStateProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'My Network',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 20),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.navy, AppColors.primary],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => context.push('/search'),
              ),
            ],
          ),

          // Connection count banner
          SliverToBoxAdapter(
            child: connectionsAsync.when(
              data: (connections) =>
                  _ConnectionBanner(count: connections.length),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // Pending Requests
          requestsAsync.when(
            data: (requests) => requests.isEmpty
                ? const SliverToBoxAdapter(child: SizedBox.shrink())
                : SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: Text(
                            'Pending Requests',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: requests.length,
                          itemBuilder: (ctx, i) => _RequestListTile(
                            request: requests[i],
                            onAccept: () => ref
                                .read(connectionControllerProvider)
                                .acceptRequest(requests[i]),
                            onReject: () => ref
                                .read(connectionControllerProvider)
                                .rejectRequest(requests[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) =>
                const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // People You May Know
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                'People You May Know',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: suggestedAsync.when(
                data: (people) => people.isEmpty
                    ? const Center(child: Text('No suggestions right now'))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: people.length,
                        itemBuilder: (context, index) {
                          final person = people[index];
                          final alreadyConnected = currentUser != null &&
                              person.connections.contains(currentUser.uid);
                          final sentRequest = sentRequestsAsync.value?.any(
                                  (r) =>
                                      r.toUid == person.uid &&
                                      r.status == ConnectionStatus.pending) ??
                              false;

                          return _SuggestedPersonCard(
                            person: person,
                            alreadyConnected: alreadyConnected,
                            isPending: sentRequest,
                            onConnect: () => _connect(context, ref, person.uid),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ),

          // My Connections list
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'My Connections',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
            ),
          ),
          connectionsAsync.when(
            data: (connections) => connections.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyConnections())
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, index) =>
                          _ConnectionListTile(user: connections[index]),
                      childCount: connections.length,
                    ),
                  ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) =>
                const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }

  Widget _buildEmptyConnections() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.people_outline,
              size: 72, color: AppColors.textHint.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('No connections yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Connect with people you know to grow your network',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ConnectionBanner extends StatelessWidget {
  final int count;
  const _ConnectionBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.navy],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.people, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count Connections',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.navy),
              ),
              const Text(
                'Keep growing your network!',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestedPersonCard extends StatelessWidget {
  final UserEntity person;
  final bool alreadyConnected;
  final bool isPending;
  final VoidCallback onConnect;

  const _SuggestedPersonCard({
    required this.person,
    required this.alreadyConnected,
    this.isPending = false,
    required this.onConnect,
  });

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return AppColors.studentColor;
      case UserRole.alumni:
        return AppColors.alumniColor;
      case UserRole.lecturer:
        return AppColors.lecturerColor;
      case UserRole.admin:
        return AppColors.adminColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _roleColor(person.role);
    return Container(
      width: 148,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PUAvatar(
            radius: 30,
            imageUrl: person.profileImageUrl,
            initials: person.name.isNotEmpty ? person.name[0] : '?',
          ),
          const SizedBox(height: 10),
          Text(
            person.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            person.headline ?? person.major ?? person.role.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: roleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              person.role.name.toUpperCase(),
              style: TextStyle(
                  color: roleColor,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: alreadyConnected
                ? OutlinedButton(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child:
                        const Text('Connected', style: TextStyle(fontSize: 11)),
                  )
                : isPending
                    ? OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Pending',
                            style: TextStyle(fontSize: 11)),
                      )
                    : ElevatedButton(
                        onPressed: onConnect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Connect',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionListTile extends StatelessWidget {
  final UserEntity user;
  const _ConnectionListTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: PUAvatar(
        radius: 26,
        imageUrl: user.profileImageUrl,
        initials: user.name.isNotEmpty ? user.name[0] : '?',
      ),
      title: Text(user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(
        user.headline ?? user.major ?? user.role.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      trailing: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        ),
        child: const Text('Message',
            style: TextStyle(color: AppColors.primary, fontSize: 12)),
      ),
    );
  }
}

class _RequestListTile extends ConsumerWidget {
  final ConnectionRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _RequestListTile({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider(request.fromUid));

    return userAsync.when(
      data: (user) => user == null
          ? const SizedBox.shrink()
          : ListTile(
              leading: PUAvatar(
                radius: 24,
                imageUrl: user.profileImageUrl,
                initials: user.name.isNotEmpty ? user.name[0] : '?',
              ),
              title: Text(user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user.headline ?? 'Wants to connect'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: onAccept,
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: onReject,
                  ),
                ],
              ),
            ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
