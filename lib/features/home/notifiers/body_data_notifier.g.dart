// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_data_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BodyDataNotifier)
final bodyDataProvider = BodyDataNotifierProvider._();

final class BodyDataNotifierProvider
    extends $NotifierProvider<BodyDataNotifier, BodyDataState> {
  BodyDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyDataNotifierHash();

  @$internal
  @override
  BodyDataNotifier create() => BodyDataNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BodyDataState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BodyDataState>(value),
    );
  }
}

String _$bodyDataNotifierHash() => r'69bf5060cc9c920ffdd89acd2cefa11b388fb495';

abstract class _$BodyDataNotifier extends $Notifier<BodyDataState> {
  BodyDataState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BodyDataState, BodyDataState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BodyDataState, BodyDataState>,
              BodyDataState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
