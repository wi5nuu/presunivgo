import '../entities/alumni_entities.dart';

abstract class AlumniRepository {
  Future<List<ReviewEntity>> getReviews(String companyName);
  Future<List<SalaryInsightEntity>> getSalaryInsights(String companyName);
  Future<void> submitReview(ReviewEntity review);
  Future<void> submitSalaryInsight(SalaryInsightEntity insight);
}
