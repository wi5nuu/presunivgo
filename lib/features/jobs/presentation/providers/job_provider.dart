import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/job_repository.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'job_provider.g.dart';

@Riverpod(keepAlive: true)
JobRepository jobRepository(JobRepositoryRef ref) {
  return JobRepositoryImpl(FirebaseFirestore.instance);
}

@riverpod
Stream<List<JobEntity>> jobList(JobListRef ref) {
  return ref.watch(jobRepositoryProvider).getJobs();
}

@riverpod
class PostJobController extends _$PostJobController {
  @override
  FutureOr<void> build() {}

  Future<void> createJob({
    required String title,
    required String company,
    required String type,
    required String location,
    required String description,
    bool isRemote = false,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final job = JobEntity(
        jobId: DateTime.now().millisecondsSinceEpoch.toString(),
        postedByUid: user.uid,
        companyName: company,
        title: title,
        type: type,
        location: location,
        isRemote: isRemote,
        description: description,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );
      await ref.read(jobRepositoryProvider).createJob(job);
    });
  }
}
