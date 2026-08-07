// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AvatarNotifier)
final avatarProvider = AvatarNotifierProvider._();

final class AvatarNotifierProvider
    extends $NotifierProvider<AvatarNotifier, AvatarState> {
  AvatarNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarNotifierHash();

  @$internal
  @override
  AvatarNotifier create() => AvatarNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarState>(value),
    );
  }
}

String _$avatarNotifierHash() => r'e98b12ce389afb66eff3197067dca8c8c95cc6ae';

abstract class _$AvatarNotifier extends $Notifier<AvatarState> {
  AvatarState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AvatarState, AvatarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AvatarState, AvatarState>,
              AvatarState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
