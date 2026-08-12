// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecordDetailNotifier)
final recordDetailProvider = RecordDetailNotifierProvider._();

final class RecordDetailNotifierProvider
    extends $NotifierProvider<RecordDetailNotifier, RecordDetailState> {
  RecordDetailNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordDetailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordDetailNotifierHash();

  @$internal
  @override
  RecordDetailNotifier create() => RecordDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordDetailState>(value),
    );
  }
}

String _$recordDetailNotifierHash() =>
    r'7607cb70c12fb80307f5a152720f4970606c920e';

abstract class _$RecordDetailNotifier extends $Notifier<RecordDetailState> {
  RecordDetailState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecordDetailState, RecordDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecordDetailState, RecordDetailState>,
              RecordDetailState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
