// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RankRepository)
final rankRepositoryProvider = RankRepositoryProvider._();

final class RankRepositoryProvider
    extends $NotifierProvider<RankRepository, RankRepository> {
  RankRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rankRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rankRepositoryHash();

  @$internal
  @override
  RankRepository create() => RankRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RankRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RankRepository>(value),
    );
  }
}

String _$rankRepositoryHash() => r'64ddde4231f0f6ba8cabbc8051c0ce6edbe0da31';

abstract class _$RankRepository extends $Notifier<RankRepository> {
  RankRepository build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RankRepository, RankRepository>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RankRepository, RankRepository>,
              RankRepository,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
