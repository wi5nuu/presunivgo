// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postRepositoryHash() => r'e904a3af28bc50ebd004d4dd9c44a459d2ba48e7';

/// See also [postRepository].
@ProviderFor(postRepository)
final postRepositoryProvider = Provider<PostRepository>.internal(
  postRepository,
  name: r'postRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PostRepositoryRef = ProviderRef<PostRepository>;
String _$feedHash() => r'12812ab6d5f215921b9ed476976d7a9bd915b716';

/// See also [feed].
@ProviderFor(feed)
final feedProvider = AutoDisposeStreamProvider<List<PostEntity>>.internal(
  feed,
  name: r'feedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$feedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FeedRef = AutoDisposeStreamProviderRef<List<PostEntity>>;
String _$postControllerHash() => r'0be9bddd881f4e3a6d04415efcb6f80e1e2eabff';

/// See also [PostController].
@ProviderFor(PostController)
final postControllerProvider =
    AutoDisposeAsyncNotifierProvider<PostController, void>.internal(
  PostController.new,
  name: r'postControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
