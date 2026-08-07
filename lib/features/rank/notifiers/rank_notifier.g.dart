// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RankNotifier)
final rankProvider = RankNotifierProvider._();

final class RankNotifierProvider
    extends $NotifierProvider<RankNotifier, RankState> {
  RankNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rankProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rankNotifierHash();

  @$internal
  @override
  RankNotifier create() => RankNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RankState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RankState>(value),
    );
  }
}

String _$rankNotifierHash() => r'87fc6cce6b84f3d5c039844d7f7d743661aec8b1';

abstract class _$RankNotifier extends $Notifier<RankState> {
  RankState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RankState, RankState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RankState, RankState>,
              RankState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
