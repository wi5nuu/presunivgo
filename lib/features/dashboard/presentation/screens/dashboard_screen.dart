import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Analytics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildStatCard('Profile Completion', '85%', Icons.person_outline),
            const SizedBox(height: 12),
            _buildStatCard(
                'Connection Growth', '+12 this week', Icons.trending_up),
            const SizedBox(height: 12),
            _buildStatCard(
                'Post Impressions', '1.2k', Icons.remove_red_eye_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.royalBlue),
        title: Text(title),
        trailing: Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.royalBlue)),
      ),
    );
  }
}
