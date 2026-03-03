import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/job_repository.dart';
import '../models/job_model.dart';

class JobRepositoryImpl implements JobRepository {
  final FirebaseFirestore _firestore;

  JobRepositoryImpl(this._firestore);

  @override
  Stream<List<JobEntity>> getJobs() {
    return _firestore
        .collection('jobs')
        .where('is_active', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => JobModel.fromJson(doc.data())).toList());
  }

  @override
  Future<void> applyForJob(
      String jobId, String applicantUid, String resumeUrl) async {
    await _firestore.collection('applications').add({
      'job_id': jobId,
      'applicant_uid': applicantUid,
      'resume_url': resumeUrl,
      'status': 'pending',
      'applied_at': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('jobs').doc(jobId).update({
      'applicants_count': FieldValue.increment(1),
    });
  }

  @override
  Future<void> createJob(JobEntity job) async {
    final model = JobModel(
      jobId: job.jobId,
      postedByUid: job.postedByUid,
      companyName: job.companyName,
      title: job.title,
      type: job.type,
      location: job.location,
      isRemote: job.isRemote,
      description: job.description,
      deadline: job.deadline,
      createdAt: job.createdAt,
    );
    await _firestore.collection('jobs').doc(job.jobId).set(model.toJson());
  }
}
