import 'package:flutter/material.dart';
import 'package:presunivgo/core/constants/app_colors.dart';
import '../../domain/entities/alumni_entities.dart';
import '../widgets/review_card.dart';

class AlumniDirectoryScreen extends StatefulWidget {
  const AlumniDirectoryScreen({super.key});

  @override
  State<AlumniDirectoryScreen> createState() => _AlumniDirectoryScreenState();
}

class _AlumniDirectoryScreenState extends State<AlumniDirectoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Alumni Directory',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.royalBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.royalBlue,
          tabs: const [
            Tab(text: 'Reviews'),
            Tab(text: 'Salaries'),
            Tab(text: 'Mentors'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReviewsTab(),
          _buildSalariesTab(),
          _buildMentorsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('New Review'),
        icon: const Icon(Icons.rate_review_outlined),
        backgroundColor: AppColors.royalBlue,
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSearchBox('Search companies...'),
        const SizedBox(height: 20),
        const Text('Recent Company Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...List.generate(5, (index) {
          final review = ReviewEntity(
            reviewId: 'r$index',
            companyName: index % 2 == 0 ? 'Shopee' : 'Traveloka',
            position: 'Software Engineer',
            rating: 4.5,
            pros: 'Great culture and benefits.',
            cons: 'High workload during peak seasons.',
            timestamp: DateTime.now(),
          );
          return ReviewCard(review: review);
        }),
      ],
    );
  }

  Widget _buildSalariesTab() {
    return const Center(child: Text('Salary insights coming soon...'));
  }

  Widget _buildMentorsTab() {
    return const Center(child: Text('Alumni Mentors list...'));
  }

  Widget _buildSearchBox(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
