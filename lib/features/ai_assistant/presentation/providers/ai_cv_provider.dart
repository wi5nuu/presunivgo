import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/ai_entities.dart';
import '../../../../core/services/upload_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'ai_cv_provider.g.dart';

@riverpod
class AICVController extends _$AICVController {
  @override
  AsyncValue<CVAnalysis?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> uploadAndAnalyzeCV(File cvFile) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();

    try {
      // 1. Upload CV
      final uploadPath =
          'users/${user.uid}/cvs/${DateTime.now().millisecondsSinceEpoch}.pdf';
      await ref.read(uploadServiceProvider).uploadFile(
            file: cvFile,
            path: uploadPath,
          );

      // 2. Simulate AI Analysis Delay/Steps
      await Future.delayed(const Duration(seconds: 1));

      // Return mock result (in real app, this would call Gemini/Backend)
      final dummyAnalysis = CVAnalysis(
        score: 85,
        summary:
            "Excellent work! Your CV is well-structured and highlights key technical skills relevant to Information Technology.",
        strengths: [
          "Strong technical core",
          "Good project descriptions",
          "Clear structure"
        ],
        improvements: [
          "Quantify impact (e.g., % improvement)",
          "Add specific certifications",
          "Optimize for ATS keywords"
        ],
        atsCompatibility: "High",
      );

      state = AsyncValue.data(dummyAnalysis);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
