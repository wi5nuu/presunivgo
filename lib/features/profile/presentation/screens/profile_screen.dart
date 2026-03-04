import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/pu_avatar.dart';
import '../providers/profile_provider.dart';
import '../../../post/presentation/providers/post_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _pickAndUploadImage(
      BuildContext context, WidgetRef ref, bool isProfile) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      if (isProfile) {
        await ref
            .read(profileControllerProvider.notifier)
            .uploadProfileImage(File(image.path));
      } else {
        await ref
            .read(profileControllerProvider.notifier)
            .uploadBannerImage(File(image.path));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${isProfile ? 'Profile' : 'Banner'} image updated!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  List<String> _sectionOrder = [
    'about',
    'experience',
    'education',
    'skills',
    'projects',
    'certs',
    'posts'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          profileState.when(
            data: (user) => user == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Please login to view profile'),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Go to Login'),
                        ),
                      ],
                    ),
                  )
                : _buildProfileContent(context, ref, user),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
          if (profileState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Uploading...',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, WidgetRef ref, UserEntity user) {
    final myPostsState = ref.watch(feedProvider);
    final myPosts =
        myPostsState.value?.where((p) => p.authorUid == user.uid).toList() ??
            [];

    return CustomScrollView(
      slivers: [
        _buildHeader(context, ref, user),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnalyticsWidget(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Profile Sections',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      icon: const Icon(Icons.drag_indicator_rounded, size: 18),
                      label: const Text('Reorder'),
                      onPressed: () => _showReorderDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._buildOrderedSections(context, ref, user, myPosts),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildOrderedSections(BuildContext context, WidgetRef ref,
      UserEntity user, List<dynamic> myPosts) {
    final widgets = <Widget>[];
    for (final key in _sectionOrder) {
      if (key == 'about') {
        widgets.add(_buildAboutSection(user));
      } else if (key == 'experience') {
        widgets.add(_buildExperienceSection(context, ref, user));
      } else if (key == 'education') {
        widgets.add(_buildEducationSection(context, ref, user));
      } else if (key == 'skills') {
        widgets.add(_buildSkillsSection(context, ref, user));
      } else if (key == 'projects') {
        widgets.add(_buildProjectsSection(context, ref, user));
      } else if (key == 'certs') {
        widgets.add(_buildCertsSection(context, ref, user));
      } else if (key == 'posts') {
        widgets.add(_buildPostsSection(myPosts));
      }

      widgets.add(const SizedBox(height: 16));
    }
    return widgets;
  }

  Widget _buildPostsSection(List<dynamic> myPosts) {
    return _buildSectionContainer(
      title: 'My Posts',
      child: Column(
        children: myPosts.isEmpty
            ? [
                const Card(
                    child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                            child: Text('No posts yet',
                                style: TextStyle(
                                    color: AppColors.textSecondary)))))
              ]
            : myPosts
                .map((post) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.border)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.content),
                            const SizedBox(height: 4),
                            Text(
                                post.timestamp
                                    .toLocal()
                                    .toString()
                                    .substring(0, 16),
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ))
                .toList(),
      ),
    );
  }

  void _showReorderDialog(BuildContext context) {
    final List<String> tempOrder = List.from(_sectionOrder);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(builder: (context, setModalState) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Drag to Reorder Sections',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      setModalState(() {
                        if (oldIndex < newIndex) newIndex -= 1;
                        final item = tempOrder.removeAt(oldIndex);
                        tempOrder.insert(newIndex, item);
                      });
                    },
                    children: tempOrder.map((key) {
                      String title = key[0].toUpperCase() + key.substring(1);
                      return ListTile(
                        key: ValueKey(key),
                        leading: const Icon(Icons.drag_handle,
                            color: AppColors.textHint),
                        title: Text(title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        tileColor: Colors.white,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _sectionOrder = tempOrder);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50)),
                  child: const Text('Save Order'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, UserEntity user) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primary,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          tooltip: 'Edit Profile',
          onPressed: () => _showEditProfileDialog(context, ref, user),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) async {
            if (value == 'logout') {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Logout', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Banner
            GestureDetector(
              onTap: () => _pickAndUploadImage(context, ref, false),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: Stack(
                  children: [
                    if (user.bannerImageUrl != null)
                      Positioned.fill(
                        child: Image.network(user.bannerImageUrl!,
                            fit: BoxFit.cover),
                      ),
                    if (user.bannerImageUrl == null)
                      const Center(
                        child: Icon(Icons.star_border_rounded,
                            color: Colors.white30, size: 80),
                      ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Profile Info
            Positioned(
              top: 130,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => _pickAndUploadImage(context, ref, true),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              PUAvatar(
                                radius: 50,
                                imageUrl: user.profileImageUrl,
                                initials:
                                    user.name.isNotEmpty ? user.name[0] : '?',
                                borderColor: user.isOpenToWork
                                    ? AppColors.success
                                    : Colors.white,
                              ),
                              if (user.isOpenToWork)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(50)),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: const Text(
                                      '#OPENTOWORK',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () =>
                            _showEditProfileDialog(context, ref, user),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.verified,
                            color: AppColors.secondary, size: 20),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.secondary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          user.activityStatus.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      if (user.currentCompany != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '@ ${user.currentCompany}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.headline ?? 'President University Student',
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.textHint),
                      SizedBox(width: 4),
                      Text(
                        'Cikarang, Indonesia',
                        style:
                            TextStyle(fontSize: 14, color: AppColors.textHint),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '500+ connections',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context, WidgetRef ref, UserEntity user) {
    final nameCtrl = TextEditingController(text: user.name);
    final headlineCtrl = TextEditingController(text: user.headline ?? '');
    final bioCtrl = TextEditingController(text: user.bio ?? '');
    final locationCtrl = TextEditingController(text: user.location ?? '');

    bool openToWork = user.isOpenToWork;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: headlineCtrl,
                  decoration: const InputDecoration(labelText: 'Headline'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bioCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationCtrl,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Open to Work',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text(
                      'Add the #OPENTOWORK badge to your profile',
                      style: TextStyle(fontSize: 12)),
                  value: openToWork,
                  activeColor: AppColors.success,
                  onChanged: (val) => setLocalState(() => openToWork = val),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                final updated = user.copyWith(
                  name: nameCtrl.text.trim(),
                  headline: headlineCtrl.text.trim(),
                  bio: bioCtrl.text.trim(),
                  location: locationCtrl.text.trim(),
                  isOpenToWork: openToWork,
                );
                await ref
                    .read(profileControllerProvider.notifier)
                    .updateProfile(updated);
                if (context.mounted) Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ), // Closes AlertDialog
      ), // Closes StatefulBuilder
    ); // Closes showDialog
  }

  void _showAddExperienceDialog(
      BuildContext context, WidgetRef ref, UserEntity user) {
    final titleCtrl = TextEditingController();
    final companyCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Experience'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: companyCtrl,
                decoration: const InputDecoration(labelText: 'Company')),
            TextField(
                controller: durationCtrl,
                decoration: const InputDecoration(labelText: 'Duration')),
            TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final newExp = {
                'title': titleCtrl.text.trim(),
                'company': companyCtrl.text.trim(),
                'duration': durationCtrl.text.trim(),
                'description': descCtrl.text.trim(),
              };
              final updatedExp =
                  List<Map<String, dynamic>>.from(user.experience)..add(newExp);
              await ref
                  .read(profileControllerProvider.notifier)
                  .updateProfile(user.copyWith(experience: updatedExp));
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddEducationDialog(
      BuildContext context, WidgetRef ref, UserEntity user) {
    final schoolCtrl = TextEditingController();
    final degreeCtrl = TextEditingController();
    final durationCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Education'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: schoolCtrl,
                decoration: const InputDecoration(labelText: 'School')),
            TextField(
                controller: degreeCtrl,
                decoration: const InputDecoration(labelText: 'Degree')),
            TextField(
                controller: durationCtrl,
                decoration: const InputDecoration(labelText: 'Duration')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final newEdu = {
                'school': schoolCtrl.text.trim(),
                'degree': degreeCtrl.text.trim(),
                'duration': durationCtrl.text.trim(),
              };
              final updatedEdu = List<Map<String, dynamic>>.from(user.education)
                ..add(newEdu);
              await ref
                  .read(profileControllerProvider.notifier)
                  .updateProfile(user.copyWith(education: updatedEdu));
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog(
      BuildContext context, WidgetRef ref, UserEntity user) {
    final skillCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Skill'),
        content: TextField(
            controller: skillCtrl,
            decoration: const InputDecoration(labelText: 'Skill')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final skill = skillCtrl.text.trim();
              if (skill.isNotEmpty) {
                final updatedSkills = List<String>.from(user.skills)
                  ..add(skill);
                await ref
                    .read(profileControllerProvider.notifier)
                    .updateProfile(user.copyWith(skills: updatedSkills));
              }
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Analytics',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: AppColors.textPrimary)),
          const Text('Private to you',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAnalyticsItem(Icons.people, '124', 'Profile views'),
              _buildAnalyticsItem(Icons.bar_chart, '542', 'Post impressions'),
              _buildAnalyticsItem(Icons.search, '89', 'Search appearances'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildAboutSection(UserEntity user) {
    return _buildSectionContainer(
      title: 'About',
      child: Text(
        user.bio ?? 'No bio provided.',
        style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
      ),
    );
  }

  Widget _buildExperienceSection(
      BuildContext context, WidgetRef ref, UserEntity user) {
    return _buildSectionContainer(
      title: 'Experience',
      onAdd: () => _showAddExperienceDialog(context, ref, user),
      child: Column(
        children: user.experience.isEmpty
            ? [
                const Text('No experience added yet.',
                    style: TextStyle(color: AppColors.textHint))
              ]
            : user.experience
                .map((exp) => _ExperienceItem(
                      title: exp['title'] ?? 'Title',
                      company: exp['company'] ?? 'Company',
                      duration: exp['duration'] ?? 'Duration',
                      description: exp['description'],
                    ))
                .toList(),
      ),
    );
  }

  Widget _buildEducationSection(
      BuildContext context, WidgetRef ref, UserEntity user) {
    return _buildSectionContainer(
      title: 'Education',
      onAdd: () => _showAddEducationDialog(context, ref, user),
      child: Column(
        children: user.education.isEmpty
            ? [
                const Text('No education added yet.',
                    style: TextStyle(color: AppColors.textHint))
              ]
            : user.education
                .map((edu) => _ExperienceItem(
                      title: edu['degree'] ?? 'Degree',
                      company: edu['school'] ?? 'School',
                      duration: edu['duration'] ?? 'Duration',
                      isEducation: true,
                    ))
                .toList(),
      ),
    );
  }

  Widget _buildSkillsSection(
      BuildContext context, WidgetRef ref, UserEntity user) {
    return _buildSectionContainer(
      title: 'Skills',
      onAdd: () => _showAddSkillDialog(context, ref, user),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: user.skills.isEmpty
            ? [
                const Text('No skills added yet.',
                    style: TextStyle(color: AppColors.textHint))
              ]
            : user.skills
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor: AppColors.surfaceVariant,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onDeleted: () async {
                        final updatedSkills = List<String>.from(user.skills)
                          ..remove(s);
                        await ref
                            .read(profileControllerProvider.notifier)
                            .updateProfile(
                                user.copyWith(skills: updatedSkills));
                      },
                      deleteIconColor: AppColors.error,
                    ))
                .toList(),
      ),
    );
  }

  Widget _buildProjectsSection(
      BuildContext context, WidgetRef ref, UserEntity user) {
    return _buildSectionContainer(
      title: 'Projects',
      onAdd: () {
        // Mock add project action, logic similar to others
      },
      child: Column(
        children: user.projects.isEmpty
            ? [
                const Text('No projects added yet.',
                    style: TextStyle(color: AppColors.textHint))
              ]
            : user.projects
                .map((proj) => _ExperienceItem(
                      title: proj['title'] ?? 'Title',
                      company: proj['role'] ?? 'Role',
                      duration: proj['duration'] ?? 'Duration',
                      description: proj['description'],
                    ))
                .toList(),
      ),
    );
  }

  Widget _buildCertsSection(
      BuildContext context, WidgetRef ref, UserEntity user) {
    return _buildSectionContainer(
      title: 'Certifications',
      onAdd: () {
        // Mock add cert action
      },
      child: Column(
        children: user.certifications.isEmpty
            ? [
                const Text('No certifications added yet.',
                    style: TextStyle(color: AppColors.textHint))
              ]
            : user.certifications
                .map((cert) => _ExperienceItem(
                      title: cert['name'] ?? 'Name',
                      company: cert['issuer'] ?? 'Issuer',
                      duration: cert['date'] ?? 'Date',
                    ))
                .toList(),
      ),
    );
  }

  Widget _buildSectionContainer(
      {required String title, required Widget child, VoidCallback? onAdd}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              if (onAdd != null)
                IconButton(
                    onPressed: onAdd, icon: const Icon(Icons.add, size: 20)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final String title;
  final String company;
  final String duration;
  final String? description;
  final bool isEducation;

  const _ExperienceItem({
    required this.title,
    required this.company,
    required this.duration,
    this.description,
    this.isEducation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(isEducation ? Icons.school : Icons.business,
                color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(company, style: const TextStyle(fontSize: 14)),
                Text(duration,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textHint)),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(description!,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
