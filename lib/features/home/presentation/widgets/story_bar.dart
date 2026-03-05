import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/story_provider.dart';

import '../../domain/entities/story_entity.dart';

class StoryBar extends ConsumerWidget {
  const StoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesState = ref.watch(storiesStreamProvider);

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: storiesState.when(
        data: (stories) {
          // Group stories by author for better UI (optional, here we'll just show unique authors)
          final uniqueStories = <String, StoryEntity>{};
          for (var s in stories) {
            if (!uniqueStories.containsKey(s.authorUid)) {
              uniqueStories[s.authorUid] = s;
            }
          }
          final displayStories = uniqueStories.values.toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: displayStories.length,
            itemBuilder: (context, index) {
              return _buildStoryItem(context, displayStories[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading stories')),
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, StoryEntity story) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => _showStoryDetail(context, story),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 2),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.surfaceVariant,
                backgroundImage: story.authorProfileImage != null
                    ? NetworkImage(story.authorProfileImage!)
                    : null,
                child: story.authorProfileImage == null
                    ? Text(story.authorName[0],
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold))
                    : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.authorName.split(' ')[0],
              style:
                  const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showStoryDetail(BuildContext context, StoryEntity story) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Story',
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: Image.network(story.imageUrl, fit: BoxFit.contain),
              ),
              Positioned(
                top: 50,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: story.authorProfileImage != null
                          ? NetworkImage(story.authorProfileImage!)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(story.authorName,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
