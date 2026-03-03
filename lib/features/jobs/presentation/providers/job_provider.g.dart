// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jobRepositoryHash() => r'08f4b1df9929769b30bc89802db5cddc1a539144';

/// See also [jobRepository].
@ProviderFor(jobRepository)
final jobRepositoryProvider = Provider<JobRepository>.internal(
  jobRepository,
  name: r'jobRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$jobRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef JobRepositoryRef = ProviderRef<JobRepository>;
String _$jobListHash() => r'fb37ad490a8a22538c4bfc20d6c69517ac60b467';

/// See also [jobList].
@ProviderFor(jobList)
final jobListProvider = AutoDisposeStreamProvider<List<JobEntity>>.internal(
  jobList,
  name: r'jobListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$jobListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef JobListRef = AutoDisposeStreamProviderRef<List<JobEntity>>;
String _$postJobControllerHash() => r'0e5814ed8ad8f7b04e3bee138f2d1a2767828b55';

/// See also [PostJobController].
@ProviderFor(PostJobController)
final postJobControllerProvider =
    AutoDisposeAsyncNotifierProvider<PostJobController, void>.internal(
  PostJobController.new,
  name: r'postJobControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postJobControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostJobController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
