import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/ai_entities.dart';

class AICVReviewScreen extends StatelessWidget {
  const AICVReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy analysis for UI demonstration
    final analysis = CVAnalysis(
      score: 82,
      summary:
          "Your CV stands out with strong technical skills, but could benefit from more quantitative achievements.",
      strengths: ["Clear layout", "Relevant tech stack", "Education sections"],
      improvements: [
        "Add metrics like % improvement or \$ saved",
        "Strengthen action verbs",
        "Link to GitHub projects"
      ],
      atsCompatibility: "High",
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI CV Review',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: CircularProgressIndicator(
                      value: analysis.score / 100,
                      strokeWidth: 10,
                      backgroundColor: AppColors.border,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    '${analysis.score}',
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(analysis.summary,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            const Text('Strengths',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success)),
            const SizedBox(height: 8),
            ...analysis.strengths.map((s) =>
                _buildPoint(s, Icons.check_circle_outline, AppColors.success)),
            const SizedBox(height: 24),
            const Text('Improvements',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning)),
            const SizedBox(height: 8),
            ...analysis.improvements.map((i) => _buildPoint(
                i, Icons.tips_and_updates_outlined, AppColors.warning)),
          ],
        ),
      ),
    );
  }

  Widget _buildPoint(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
