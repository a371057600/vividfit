// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecordRepository)
final recordRepositoryProvider = RecordRepositoryProvider._();

final class RecordRepositoryProvider
    extends $NotifierProvider<RecordRepository, RecordRepository> {
  RecordRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordRepositoryHash();

  @$internal
  @override
  RecordRepository create() => RecordRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordRepository>(value),
    );
  }
}

String _$recordRepositoryHash() => r'aa624f08b64b112405a1c363e03a0156dca659d4';

abstract class _$RecordRepository extends $Notifier<RecordRepository> {
  RecordRepository build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecordRepository, RecordRepository>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecordRepository, RecordRepository>,
              RecordRepository,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
