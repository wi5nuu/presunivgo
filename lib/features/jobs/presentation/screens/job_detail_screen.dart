import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/job_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final JobEntity job;
  const JobDetailScreen({super.key, required this.job});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showApplySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ApplyBottomSheet(job: widget.job),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final daysLeft = job.deadline.difference(DateTime.now()).inDays;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: AppColors.navy,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.navy, AppColors.primary],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Company logo placeholder
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: const Icon(Icons.business,
                            color: AppColors.primary, size: 30),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        job.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.companyName,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Meta info strip
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(
                      icon: Icons.location_on_outlined, label: job.location),
                  _MetaChip(
                      icon: Icons.work_outline,
                      label: job.type,
                      color: AppColors.primary),
                  if (job.isRemote)
                    _MetaChip(
                        icon: Icons.wifi,
                        label: 'Remote',
                        color: AppColors.success),
                  _MetaChip(
                      icon: Icons.timer_outlined,
                      label: daysLeft > 0
                          ? '$daysLeft days left'
                          : 'Deadline passed',
                      color:
                          daysLeft > 7 ? AppColors.success : AppColors.error),
                  _MetaChip(
                      icon: Icons.people_outline,
                      label: '${job.applicantsCount} applicants'),
                  if (job.salaryMin != null)
                    _MetaChip(
                        icon: Icons.attach_money,
                        label:
                            '${job.salaryMin!.round()} – ${job.salaryMax?.round() ?? '?'}K',
                        color: AppColors.success),
                ],
              ),
            ),
          ),

          // Tabs
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Requirements'),
                  Tab(text: 'Company'),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 420,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(job: job),
                  _RequirementsTab(job: job),
                  _CompanyTab(job: job),
                ],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _showApplySheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text(
              'Apply Now',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tabs ─────────────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final JobEntity job;
  const _OverviewTab({required this.job});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Job Description',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(job.description,
              style: const TextStyle(
                  color: AppColors.textSecondary, height: 1.6, fontSize: 14)),
          if (job.requiredSkills.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('Required Skills',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.requiredSkills
                  .map((skill) => Chip(
                        label:
                            Text(skill, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.primary.withOpacity(0.08),
                        side: BorderSide(
                            color: AppColors.primary.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _RequirementsTab extends StatelessWidget {
  final JobEntity job;
  const _RequirementsTab({required this.job});

  @override
  Widget build(BuildContext context) {
    if (job.requirements.isEmpty) {
      return const Center(child: Text('No specific requirements listed.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: job.requirements.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(job.requirements[index],
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                      fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyTab extends StatelessWidget {
  final JobEntity job;
  const _CompanyTab({required this.job});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                const Icon(Icons.business, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 16),
          Text(job.companyName,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'This position is offered by the company above.\nFor more information, please apply and check your email.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ─── Apply Bottom Sheet ───────────────────────────────────────────────────────

class ApplyBottomSheet extends ConsumerStatefulWidget {
  final JobEntity job;
  const ApplyBottomSheet({super.key, required this.job});

  @override
  ConsumerState<ApplyBottomSheet> createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends ConsumerState<ApplyBottomSheet> {
  PlatformFile? _cvFile;
  final _coverLetterCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  bool _isSubmitting = false;
  double _uploadProgress = 0;

  @override
  void dispose() {
    _coverLetterCtrl.dispose();
    _linkedinCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() => _cvFile = result.files.single);
    }
  }

  Future<void> _submitApplication() async {
    final currentUser = ref.read(authStateProvider).value;
    if (currentUser == null) return;

    setState(() {
      _isSubmitting = true;
      _uploadProgress = 0;
    });

    try {
      // Simulate upload progress
      for (var i = 0; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 80));
        if (mounted) setState(() => _uploadProgress = i / 10);
      }

      await FirebaseFirestore.instance.collection('applications').add({
        'job_id': widget.job.jobId,
        'job_title': widget.job.title,
        'company': widget.job.companyName,
        'applicant_uid': currentUser.uid,
        'resume_url': _cvFile?.name ?? 'no_cv_attached',
        'cover_letter': _coverLetterCtrl.text.trim(),
        'linkedin_url': _linkedinCtrl.text.trim(),
        'status': 'pending',
        'applied_at': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.job.jobId)
          .update({
        'applicants_count': FieldValue.increment(1),
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully! 🚀'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Apply for ${widget.job.title}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'at ${widget.job.companyName}',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),

          // CV Upload
          GestureDetector(
            onTap: _pickCV,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cvFile != null
                    ? AppColors.success.withOpacity(0.05)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _cvFile != null ? AppColors.success : AppColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _cvFile != null
                        ? Icons.check_circle
                        : Icons.upload_file_outlined,
                    color:
                        _cvFile != null ? AppColors.success : AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _cvFile != null
                              ? _cvFile!.name
                              : 'Upload Your CV / Resume',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _cvFile != null
                                ? AppColors.success
                                : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          'PDF, DOC, or DOCX accepted',
                          style: TextStyle(
                              color: AppColors.textHint, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cover letter
          TextField(
            controller: _coverLetterCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Cover letter (optional)...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true,
              fillColor: AppColors.surfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // LinkedIn
          TextField(
            controller: _linkedinCtrl,
            decoration: InputDecoration(
              hintText: 'LinkedIn URL (optional)',
              prefixIcon: const Icon(Icons.link),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true,
              fillColor: AppColors.surfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          // Progress indicator
          if (_isSubmitting) ...[
            LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: AppColors.border,
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_uploadProgress * 100).round()}% Uploading...',
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 12),
          ],

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitApplication,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Submit Application',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Meta Chip ─────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetaChip(
      {required this.icon,
      required this.label,
      this.color = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
