class ReviewEntity {
  final String reviewId;
  final String companyName;
  final String position;
  final double rating;
  final String pros;
  final String cons;
  final String? adviceToManagement;
  final bool isAnonymous;
  final String? reviewerUid;
  final DateTime timestamp;

  ReviewEntity({
    required this.reviewId,
    required this.companyName,
    required this.position,
    required this.rating,
    required this.pros,
    required this.cons,
    this.adviceToManagement,
    this.isAnonymous = true,
    this.reviewerUid,
    required this.timestamp,
  });
}

class SalaryInsightEntity {
  final String insightId;
  final String companyName;
  final String position;
  final double baseSalary;
  final double? bonus;
  final String currency;
  final String location;
  final DateTime timestamp;

  SalaryInsightEntity({
    required this.insightId,
    required this.companyName,
    required this.position,
    required this.baseSalary,
    this.bonus,
    this.currency = 'IDR',
    required this.location,
    required this.timestamp,
  });
}
