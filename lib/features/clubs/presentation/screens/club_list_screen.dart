import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:presunivgo/core/constants/app_colors.dart';
import '../../domain/entities/club_entities.dart';
import '../providers/club_provider.dart';

class ClubListScreen extends ConsumerWidget {
  const ClubListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsState = ref.watch(clubListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Student Clubs',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => _showCreateClubDialog(context, ref),
          ),
        ],
      ),
      body: clubsState.when(
        data: (clubs) => clubs.isEmpty
            ? const Center(child: Text('No clubs found'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  return _buildClubCard(context, ref, clubs[index]);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showCreateClubDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create a Club'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Club Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              Navigator.of(ctx).pop();
              await ref.read(clubControllerProvider.notifier).createClub(
                    name: nameCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Club created!')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildClubCard(BuildContext context, WidgetRef ref, ClubEntity club) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => context.push('/clubs/${club.clubId}'),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: club.bannerUrl != null
                  ? Image.network(club.bannerUrl!, fit: BoxFit.cover)
                  : const Center(
                      child: Icon(Icons.groups,
                          color: AppColors.royalBlue, size: 50)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(club.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${club.memberUids.length} members • Active now',
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(clubControllerProvider.notifier)
                        .joinClub(club.clubId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 2,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    child: const Text('Join'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
