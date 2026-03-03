import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/job_card.dart';
import '../providers/job_provider.dart';

class JobMarketplaceScreen extends ConsumerStatefulWidget {
  const JobMarketplaceScreen({super.key});

  @override
  ConsumerState<JobMarketplaceScreen> createState() =>
      _JobMarketplaceScreenState();
}

class _JobMarketplaceScreenState extends ConsumerState<JobMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Job Marketplace',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.royalBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.royalBlue,
          tabs: const [
            Tab(text: 'Discover'),
            Tab(text: 'Applied'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverTab(),
          _buildAppliedTab(),
          const Center(child: Text('No saved jobs')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPostJobDialog(context),
        label: const Text('Post a Job'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.navy,
      ),
    );
  }

  void _showPostJobDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final companyCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedType = 'Full-time';
    bool isRemote = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Post a Job'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Job Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: companyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'e.g. Cikarang, Indonesia',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Full-time',
                    'Part-time',
                    'Internship',
                    'Contract',
                    'Freelance'
                  ]
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedType = val!),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Remote / Work from Home'),
                  value: isRemote,
                  onChanged: (val) => setDialogState(() => isRemote = val!),
                  contentPadding: EdgeInsets.zero,
                ),
                TextField(
                  controller: descCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (titleCtrl.text.isEmpty ||
                    companyCtrl.text.isEmpty ||
                    descCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill in all required fields')),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                await ref.read(postJobControllerProvider.notifier).createJob(
                      title: titleCtrl.text.trim(),
                      company: companyCtrl.text.trim(),
                      type: selectedType,
                      location: locationCtrl.text.trim().isEmpty
                          ? 'Not specified'
                          : locationCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      isRemote: isRemote,
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job posted successfully!')),
                  );
                }
              },
              child: const Text('Post Job'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverTab() {
    final jobsState = ref.watch(jobListProvider);

    return jobsState.when(
      data: (jobs) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchAndFilter(),
          const SizedBox(height: 20),
          const Text(
            'Recommended for you',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Based on your profile and skills',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          if (jobs.isEmpty)
            const Center(child: Text('No jobs available at the moment'))
          else
            ...jobs.map((job) => JobCard(job: job)),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search jobs, companies...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Internship', true),
              _buildFilterChip('Full-time', false),
              _buildFilterChip('Remote', false),
              _buildFilterChip('Design', false),
              _buildFilterChip('Engineering', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {},
        backgroundColor: Colors.white,
        selectedColor: AppColors.royalBlue.withOpacity(0.2),
        checkmarkColor: AppColors.royalBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isSelected ? AppColors.royalBlue : AppColors.border),
        ),
      ),
    );
  }

  Widget _buildAppliedTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Your Application Status',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildPipelineCard(
          'Software Engineer Intern',
          'Google',
          'Interviewing',
          2,
        ),
        const SizedBox(height: 12),
        _buildPipelineCard(
          'Research Assistant',
          'President University',
          'Applied',
          0,
        ),
      ],
    );
  }

  Widget _buildPipelineCard(
      String title, String company, String status, int step) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(company, style: const TextStyle(color: AppColors.royalBlue)),
            const SizedBox(height: 16),
            Row(
              children: List.generate(4, (index) {
                final isCompleted = index <= step;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: isCompleted ? AppColors.success : AppColors.border,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: $status',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
