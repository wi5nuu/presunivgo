import 'dart:async';

abstract class AIService {
  Future<String> getCareerAdvice(String query, String userContext);
  Future<List<String>> optimizeProfile(Map<String, dynamic> profileData);
}

class GeminiServiceMock implements AIService {
  @override
  Future<String> getCareerAdvice(String query, String userContext) async {
    // Simulate Gemini delay
    await Future.delayed(const Duration(seconds: 2));

    return "Based on your background in IT and current market trends at President University, I recommend focusing on Flutter and Firebase. "
        "Many alumni are successfully transitioning into Full-stack roles. Would you like me to analyze your skills further?";
  }

  @override
  Future<List<String>> optimizeProfile(Map<String, dynamic> profileData) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      "Add a more professional headline containing your target role.",
      "List specific projects you've worked on in IT Club.",
      "Include certifications like Google Cloud or AWS."
    ];
  }
}
