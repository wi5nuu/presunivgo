import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/pu_button.dart';
import '../providers/post_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/pu_avatar.dart';

class CreatePostModal extends ConsumerStatefulWidget {
  const CreatePostModal({super.key});

  @override
  ConsumerState<CreatePostModal> createState() => _CreatePostModalState();
}

class _CreatePostModalState extends ConsumerState<CreatePostModal> {
  final _textController = TextEditingController();
  String _visibility = 'Public';
  final List<String> _visibilities = ['Public', 'Connections', 'Private'];
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _handlePost() async {
    if (_textController.text.trim().isEmpty && _selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      List<String> imageUrls = [];
      if (_selectedImage != null) {
        final url = await ref
            .read(postControllerProvider.notifier)
            .uploadMedia(_selectedImage!);
        imageUrls.add(url);
      }

      await ref.read(postControllerProvider.notifier).createPost(
            _textController.text.trim(),
            imageUrls,
            _visibility.toLowerCase(),
          );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postControllerProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildUserInfo(),
          const SizedBox(height: 16),
          _buildVisibilitySelector(),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImage = null),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          _buildAttachmentToolbar(),
          const SizedBox(height: 16),
          PUButton(
            text: 'Post',
            isLoading: _isUploading || postState.isLoading,
            onPressed: (_textController.text.trim().isNotEmpty ||
                    _selectedImage != null)
                ? _handlePost
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          'Create Post',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Schedule'),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return Row(
      children: [
        PUAvatar(
          radius: 20,
          imageUrl: user?.profileImageUrl,
          initials: user?.name.isNotEmpty == true ? user!.name[0] : '?',
        ),
        const SizedBox(width: 12),
        Text(
          user?.name ?? 'Your Name',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildVisibilitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _visibility,
          items: _visibilities.map((v) {
            return DropdownMenuItem(
                value: v, child: Text(v, style: const TextStyle(fontSize: 12)));
          }).toList(),
          onChanged: (val) => setState(() => _visibility = val!),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildAttachmentToolbar() {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.image_outlined, color: AppColors.royalBlue),
            onPressed: _pickImage),
        IconButton(
            icon: const Icon(Icons.description_outlined,
                color: AppColors.textSecondary),
            onPressed: () {}),
        IconButton(
            icon: const Icon(Icons.alternate_email,
                color: AppColors.textSecondary),
            onPressed: () {}),
        IconButton(
            icon: const Icon(Icons.tag, color: AppColors.textSecondary),
            onPressed: () {}),
      ],
    );
  }
}
