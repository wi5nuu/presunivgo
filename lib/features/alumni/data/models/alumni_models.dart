import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/alumni_entities.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.reviewId,
    required super.companyName,
    required super.position,
    required super.rating,
    required super.pros,
    required super.cons,
    super.adviceToManagement,
    super.isAnonymous,
    super.reviewerUid,
    required super.timestamp,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['review_id'] as String,
      companyName: json['company_name'] as String,
      position: json['position'] as String,
      rating: (json['rating'] as num).toDouble(),
      pros: json['pros'] as String,
      cons: json['cons'] as String,
      adviceToManagement: json['advice_to_management'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? true,
      reviewerUid: json['reviewer_uid'] as String?,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'company_name': companyName,
      'position': position,
      'rating': rating,
      'pros': pros,
      'cons': cons,
      'advice_to_management': adviceToManagement,
      'is_anonymous': isAnonymous,
      'reviewer_uid': reviewerUid,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class SalaryInsightModel extends SalaryInsightEntity {
  SalaryInsightModel({
    required super.insightId,
    required super.companyName,
    required super.position,
    required super.baseSalary,
    super.bonus,
    super.currency,
    required super.location,
    required super.timestamp,
  });

  factory SalaryInsightModel.fromJson(Map<String, dynamic> json) {
    return SalaryInsightModel(
      insightId: json['insight_id'] as String,
      companyName: json['company_name'] as String,
      position: json['position'] as String,
      baseSalary: (json['base_salary'] as num).toDouble(),
      bonus: (json['bonus'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'IDR',
      location: json['location'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insight_id': insightId,
      'company_name': companyName,
      'position': position,
      'base_salary': baseSalary,
      'bonus': bonus,
      'currency': currency,
      'location': location,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
