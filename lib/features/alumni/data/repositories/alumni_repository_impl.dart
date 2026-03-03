import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/alumni_entities.dart';
import '../../domain/repositories/alumni_repository.dart';
import '../models/alumni_models.dart';

class AlumniRepositoryImpl implements AlumniRepository {
  final FirebaseFirestore _firestore;

  AlumniRepositoryImpl(this._firestore);

  @override
  Future<List<ReviewEntity>> getReviews(String companyName) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('company_name', isEqualTo: companyName)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ReviewModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<SalaryInsightEntity>> getSalaryInsights(
      String companyName) async {
    final snapshot = await _firestore
        .collection('salary_insights')
        .where('company_name', isEqualTo: companyName)
        .get();

    return snapshot.docs
        .map((doc) => SalaryInsightModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> submitReview(ReviewEntity review) async {
    final model = ReviewModel(
      reviewId: review.reviewId,
      companyName: review.companyName,
      position: review.position,
      rating: review.rating,
      pros: review.pros,
      cons: review.cons,
      isAnonymous: review.isAnonymous,
      reviewerUid: review.reviewerUid,
      timestamp: DateTime.now(),
    );
    await _firestore
        .collection('reviews')
        .doc(review.reviewId)
        .set(model.toJson());
  }

  @override
  Future<void> submitSalaryInsight(SalaryInsightEntity insight) async {
    final model = SalaryInsightModel(
      insightId: insight.insightId,
      companyName: insight.companyName,
      position: insight.position,
      baseSalary: insight.baseSalary,
      location: insight.location,
      timestamp: DateTime.now(),
    );
    await _firestore
        .collection('salary_insights')
        .doc(insight.insightId)
        .set(model.toJson());
  }
}
