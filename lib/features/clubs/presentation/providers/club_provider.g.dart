// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clubRepositoryHash() => r'c21aa6e3e3616d6f24cdfeb351ad240ab3ae7991';

/// See also [clubRepository].
@ProviderFor(clubRepository)
final clubRepositoryProvider = Provider<ClubRepository>.internal(
  clubRepository,
  name: r'clubRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clubRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ClubRepositoryRef = ProviderRef<ClubRepository>;
String _$clubListHash() => r'14a59dce55e1549aeb0920fd0f236af8cc494fd1';

/// See also [clubList].
@ProviderFor(clubList)
final clubListProvider = AutoDisposeStreamProvider<List<ClubEntity>>.internal(
  clubList,
  name: r'clubListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$clubListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ClubListRef = AutoDisposeStreamProviderRef<List<ClubEntity>>;
String _$channelListHash() => r'b68b52e6992e287741361dce6c759bc391d6484f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [channelList].
@ProviderFor(channelList)
const channelListProvider = ChannelListFamily();

/// See also [channelList].
class ChannelListFamily extends Family<AsyncValue<List<ChannelEntity>>> {
  /// See also [channelList].
  const ChannelListFamily();

  /// See also [channelList].
  ChannelListProvider call(
    String clubId,
  ) {
    return ChannelListProvider(
      clubId,
    );
  }

  @override
  ChannelListProvider getProviderOverride(
    covariant ChannelListProvider provider,
  ) {
    return call(
      provider.clubId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'channelListProvider';
}

/// See also [channelList].
class ChannelListProvider
    extends AutoDisposeStreamProvider<List<ChannelEntity>> {
  /// See also [channelList].
  ChannelListProvider(
    String clubId,
  ) : this._internal(
          (ref) => channelList(
            ref as ChannelListRef,
            clubId,
          ),
          from: channelListProvider,
          name: r'channelListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelListHash,
          dependencies: ChannelListFamily._dependencies,
          allTransitiveDependencies:
              ChannelListFamily._allTransitiveDependencies,
          clubId: clubId,
        );

  ChannelListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clubId,
  }) : super.internal();

  final String clubId;

  @override
  Override overrideWith(
    Stream<List<ChannelEntity>> Function(ChannelListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChannelListProvider._internal(
        (ref) => create(ref as ChannelListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clubId: clubId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ChannelEntity>> createElement() {
    return _ChannelListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelListProvider && other.clubId == clubId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clubId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChannelListRef on AutoDisposeStreamProviderRef<List<ChannelEntity>> {
  /// The parameter `clubId` of this provider.
  String get clubId;
}

class _ChannelListProviderElement
    extends AutoDisposeStreamProviderElement<List<ChannelEntity>>
    with ChannelListRef {
  _ChannelListProviderElement(super.provider);

  @override
  String get clubId => (origin as ChannelListProvider).clubId;
}

String _$clubControllerHash() => r'd741e7efbceee7c2dec78178f82726bdf44e2ffa';

/// See also [ClubController].
@ProviderFor(ClubController)
final clubControllerProvider =
    AutoDisposeAsyncNotifierProvider<ClubController, void>.internal(
  ClubController.new,
  name: r'clubControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clubControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClubController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
