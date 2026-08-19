// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_main_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecordMainNotifier)
final recordMainProvider = RecordMainNotifierProvider._();

final class RecordMainNotifierProvider
    extends $NotifierProvider<RecordMainNotifier, RecordMainState> {
  RecordMainNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordMainProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordMainNotifierHash();

  @$internal
  @override
  RecordMainNotifier create() => RecordMainNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordMainState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordMainState>(value),
    );
  }
}

String _$recordMainNotifierHash() =>
    r'88e962e0652eb9dac9022fa150b2c944010e1d3b';

abstract class _$RecordMainNotifier extends $Notifier<RecordMainState> {
  RecordMainState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecordMainState, RecordMainState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecordMainState, RecordMainState>,
              RecordMainState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
