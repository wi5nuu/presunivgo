// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'306a602230a186a0f4b7faf7537bdf4d684c21f4';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$chatListHash() => r'8b79c63bd234c8cb4a119e118e4f23658493e5d2';

/// See also [chatList].
@ProviderFor(chatList)
final chatListProvider = AutoDisposeStreamProvider<List<ChatEntity>>.internal(
  chatList,
  name: r'chatListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatListRef = AutoDisposeStreamProviderRef<List<ChatEntity>>;
String _$messageStreamHash() => r'f0562e53a5b6f90844c50fd652ae871d2b7bffc1';

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

/// See also [messageStream].
@ProviderFor(messageStream)
const messageStreamProvider = MessageStreamFamily();

/// See also [messageStream].
class MessageStreamFamily extends Family<AsyncValue<List<MessageEntity>>> {
  /// See also [messageStream].
  const MessageStreamFamily();

  /// See also [messageStream].
  MessageStreamProvider call(
    String chatId,
  ) {
    return MessageStreamProvider(
      chatId,
    );
  }

  @override
  MessageStreamProvider getProviderOverride(
    covariant MessageStreamProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'messageStreamProvider';
}

/// See also [messageStream].
class MessageStreamProvider
    extends AutoDisposeStreamProvider<List<MessageEntity>> {
  /// See also [messageStream].
  MessageStreamProvider(
    String chatId,
  ) : this._internal(
          (ref) => messageStream(
            ref as MessageStreamRef,
            chatId,
          ),
          from: messageStreamProvider,
          name: r'messageStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messageStreamHash,
          dependencies: MessageStreamFamily._dependencies,
          allTransitiveDependencies:
              MessageStreamFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  MessageStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    Stream<List<MessageEntity>> Function(MessageStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessageStreamProvider._internal(
        (ref) => create(ref as MessageStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MessageEntity>> createElement() {
    return _MessageStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageStreamProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MessageStreamRef on AutoDisposeStreamProviderRef<List<MessageEntity>> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _MessageStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<MessageEntity>>
    with MessageStreamRef {
  _MessageStreamProviderElement(super.provider);

  @override
  String get chatId => (origin as MessageStreamProvider).chatId;
}

String _$chatControllerHash() => r'bc2f508237250dc3f2f365ba733da81f22b313f8';

/// See also [ChatController].
@ProviderFor(ChatController)
final chatControllerProvider =
    AutoDisposeAsyncNotifierProvider<ChatController, void>.internal(
  ChatController.new,
  name: r'chatControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
