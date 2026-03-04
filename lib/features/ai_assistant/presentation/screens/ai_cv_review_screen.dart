import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/ai_entities.dart';
import '../providers/ai_cv_provider.dart';

class AICVReviewScreen extends ConsumerStatefulWidget {
  const AICVReviewScreen({super.key});

  @override
  ConsumerState<AICVReviewScreen> createState() => _AICVReviewScreenState();
}

class _AICVReviewScreenState extends ConsumerState<AICVReviewScreen> {
  Future<void> _pickAndAnalyzeCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      await ref
          .read(aICVControllerProvider.notifier)
          .uploadAndAnalyzeCV(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aICVControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI CV Review',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: aiState.when(
        data: (analysis) => analysis == null
            ? _buildUploadPrompt()
            : _buildAnalysisContent(analysis),
        loading: () => _buildLoadingState(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildUploadPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description_outlined,
                size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text(
              'Upload your CV for AI Review',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Get instant feedback on your CV structure, content, and ATS compatibility.',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _pickAndAnalyzeCV,
              icon: const Icon(Icons.upload_file),
              label: const Text('Select CV (PDF/DOC)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          const Text(
            'AI is analyzing your CV...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('This may take a few moments',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildAnalysisContent(CVAnalysis analysis) {
    return SingleChildScrollView(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: _pickAndAnalyzeCV,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Re-upload'),
              ),
            ],
          ),
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
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Assistant'),
            ),
          ),
        ],
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
