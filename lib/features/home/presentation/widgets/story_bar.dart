import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/story_provider.dart';
import '../../domain/entities/story_entity.dart';

class StoryBar extends ConsumerWidget {
  const StoryBar({super.key});

  Future<void> _pickAndUploadStory(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      final file = File(image.path);
      await ref.read(storyControllerProvider.notifier).uploadStory(file);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Story uploaded successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final storiesState = ref.watch(storiesStreamProvider);
    final uploadingState = ref.watch(storyControllerProvider);

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
            itemCount: displayStories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddStory(
                    context, ref, profileState.value, uploadingState.isLoading);
              }
              return _buildStoryItem(context, displayStories[index - 1]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading stories')),
      ),
    );
  }

  Widget _buildAddStory(
      BuildContext context, WidgetRef ref, dynamic user, bool isUploading) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: isUploading ? null : () => _pickAndUploadStory(context, ref),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.surfaceVariant,
                    backgroundImage: user?.profileImageUrl != null
                        ? NetworkImage(user!.profileImageUrl!)
                        : null,
                    child: user?.profileImageUrl == null || isUploading
                        ? (isUploading
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : const Icon(Icons.person,
                                color: AppColors.textHint, size: 30))
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Your Story',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary),
            ),
          ],
        ),
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
