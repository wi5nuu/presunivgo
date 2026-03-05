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
    'featured',
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
                _buildAnalyticsWidget(user),
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
      } else if (key == 'featured') {
        widgets.add(_buildFeaturedSection(user));
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
      expandedHeight: 460,
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
                        onPressed: () => _showOpenToDialog(context, ref, user),
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
                  const SizedBox(height: 12),
                  // Name and Verification
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.verified,
                            color: AppColors.secondary, size: 22),
                      ],
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showVerificationInfo(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shield_outlined,
                                  size: 12, color: AppColors.secondary),
                              SizedBox(width: 4),
                              Text('Add verification badge',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Headline (Multi-line)
                  Text(
                    user.headline ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // School and Company
                  Row(
                    children: [
                      const Icon(Icons.business_center,
                          size: 16, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text(
                        user.currentCompany ?? '',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Text(' • ',
                          style: TextStyle(color: Colors.white70)),
                      Text(
                        user.faculty ?? '',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Text(
                    user.location ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  // Connection count
                  Text(
                    '${user.connections.length} connections',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Professional Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _showOpenToDialog(context, ref, user),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Open to',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              _showAddSectionMenu(context, ref, user),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Add section',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon:
                              const Icon(Icons.more_horiz, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // LinkIdn style button
                  OutlinedButton(
                    onPressed: () => _showEnhanceProfileDialog(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text('Enhance profile',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
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

  void _showOpenToDialog(BuildContext context, WidgetRef ref, UserEntity user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          const Text('Show recruiters you\'re open',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListTile(
            leading:
                const CircleAvatar(child: Icon(Icons.business_center_outlined)),
            title: const Text('Finding a new job'),
            subtitle: const Text('Show the #OPENTOWORK badge on your profile'),
            trailing: Switch(
              value: user.isOpenToWork,
              onChanged: (val) async {
                await ref
                    .read(profileControllerProvider.notifier)
                    .updateProfile(user.copyWith(isOpenToWork: val));
                if (context.mounted) Navigator.pop(ctx);
              },
            ),
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_add_outlined)),
            title: const Text('Hiring'),
            subtitle: const Text('Share that you\'re hiring to find talent'),
            onTap: () => Navigator.pop(ctx),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showAddSectionMenu(
      BuildContext context, WidgetRef ref, UserEntity user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Add to Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.business_center),
            title: const Text('Add experience'),
            onTap: () {
              Navigator.pop(ctx);
              _showAddExperienceDialog(context, ref, user);
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Add education'),
            onTap: () {
              Navigator.pop(ctx);
              _showAddEducationDialog(context, ref, user);
            },
          ),
          ListTile(
            leading: const Icon(Icons.psychology),
            title: const Text('Add skill'),
            onTap: () {
              Navigator.pop(ctx);
              _showAddSkillDialog(context, ref, user);
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Add project'),
            onTap: () {
              Navigator.pop(ctx);
              _showAddProjectDialog(context, ref, user);
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_membership),
            title: const Text('Add certification'),
            onTap: () {
              Navigator.pop(ctx);
              _showAddCertificationDialog(context, ref, user);
            },
          ),
        ],
      ),
    );
  }

  void _showAddProjectDialog(
      BuildContext context, WidgetRef ref, UserEntity user) {
    final titleCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Project Title')),
            TextField(
                controller: roleCtrl,
                decoration: const InputDecoration(labelText: 'Your Role')),
            TextField(
                controller: durationCtrl,
                decoration: const InputDecoration(labelText: 'Duration')),
            TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final newProj = {
                'title': titleCtrl.text.trim(),
                'role': roleCtrl.text.trim(),
                'duration': durationCtrl.text.trim(),
                'description': descCtrl.text.trim(),
              };
              final updatedProjs =
                  List<Map<String, dynamic>>.from(user.projects)..add(newProj);
              await ref
                  .read(profileControllerProvider.notifier)
                  .updateProfile(user.copyWith(projects: updatedProjs));
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddCertificationDialog(
      BuildContext context, WidgetRef ref, UserEntity user) {
    final nameCtrl = TextEditingController();
    final issuerCtrl = TextEditingController();
    final dateCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Certification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration:
                    const InputDecoration(labelText: 'Certification Name')),
            TextField(
                controller: issuerCtrl,
                decoration:
                    const InputDecoration(labelText: 'Issuing Organization')),
            TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(labelText: 'Issue Date')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final newCert = {
                'name': nameCtrl.text.trim(),
                'issuer': issuerCtrl.text.trim(),
                'date': dateCtrl.text.trim(),
              };
              final updatedCerts =
                  List<Map<String, dynamic>>.from(user.certifications)
                    ..add(newCert);
              await ref
                  .read(profileControllerProvider.notifier)
                  .updateProfile(user.copyWith(certifications: updatedCerts));
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEnhanceProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.secondary),
            SizedBox(width: 8),
            Text('AI Profile Enhancer'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'COMING SOON!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.secondary),
            ),
            SizedBox(height: 16),
            Text(
              'Our AI Career Mentor will soon be able to analyze your profile and provide personalized suggestions to make it stand out to recruiters.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
            child: const Text('Exciting!'),
          ),
        ],
      ),
    );
  }

  void _showVerificationInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profile Verification'),
        content: const Text(
            'Verification badges are currently managed by the university administration. Please ensure your student/alumni status is updated to receive your badge automatically.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Got it')),
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

  Widget _buildAnalyticsWidget(UserEntity user) {
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
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimary)),
          Row(
            children: [
              const Icon(Icons.visibility_off,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              const Text('Private to you',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          _buildAnalyticsDetailItem(
            Icons.people_alt_rounded,
            '0 profile views',
            'Discover who\'s viewed your profile.',
          ),
          const Divider(height: 24),
          _buildAnalyticsDetailItem(
            Icons.bar_chart_rounded,
            '0 post impressions',
            'Check out who\'s engaging with your posts.\nPast 7 days',
          ),
          const Divider(height: 24),
          _buildAnalyticsDetailItem(
            Icons.search_rounded,
            '0 search appearances',
            'See how often you appear in search results.',
          ),
          const SizedBox(height: 12),
          const Divider(),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Show all analytics',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsDetailItem(
      IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(UserEntity user) {
    return _buildSectionContainer(
      title: 'Featured',
      onAdd: () {},
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text('No featured items to show',
              style: TextStyle(color: AppColors.textHint)),
        ),
      ),
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
      title: 'Top skills',
      onAdd: () => _showAddSkillDialog(context, ref, user),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.diamond_outlined,
                  color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  user.skills.take(5).join(' • '),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
              ),
              const Icon(Icons.arrow_forward, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          Wrap(
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
        ],
      ),
    );
  }

  Widget _buildProjectsSection(
      BuildContext context, WidgetRef ref, UserEntity user) {
    return _buildSectionContainer(
      title: 'Projects',
      onAdd: () => _showAddProjectDialog(context, ref, user),
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
      onAdd: () => _showAddCertificationDialog(context, ref, user),
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
