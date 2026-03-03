import '../entities/job_entity.dart';

abstract class JobRepository {
  Stream<List<JobEntity>> getJobs();
  Future<void> applyForJob(String jobId, String applicantUid, String resumeUrl);
  Future<void> createJob(JobEntity job);
}
