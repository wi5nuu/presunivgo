class AIChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  AIChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class CareerAdvice {
  final String title;
  final String advice;
  final List<String> actionItems;

  CareerAdvice({
    required this.title,
    required this.advice,
    this.actionItems = const [],
  });
}

class CVAnalysis {
  final int score;
  final String summary;
  final List<String> strengths;
  final List<String> improvements;
  final String atsCompatibility;

  CVAnalysis({
    required this.score,
    required this.summary,
    required this.strengths,
    required this.improvements,
    required this.atsCompatibility,
  });
}

class CoverLetter {
  final String content;
  final String tone;

  CoverLetter({
    required this.content,
    required this.tone,
  });
}
