// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecordListNotifier)
final recordListProvider = RecordListNotifierProvider._();

final class RecordListNotifierProvider
    extends $NotifierProvider<RecordListNotifier, RecordListState> {
  RecordListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordListNotifierHash();

  @$internal
  @override
  RecordListNotifier create() => RecordListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordListState>(value),
    );
  }
}

String _$recordListNotifierHash() =>
    r'4be948b7f9fad10f1a181990bd21355d88e2ec74';

abstract class _$RecordListNotifier extends $Notifier<RecordListState> {
  RecordListState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecordListState, RecordListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecordListState, RecordListState>,
              RecordListState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
