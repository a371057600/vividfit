// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_record_local_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 运动记录本地存储仓库。
///
/// 基于 shared_preferences 实现，以 JSON 数组形式持久化运动记录。
/// 最多保留最近 [_maxRecords] 条（200 条），超出时自动丢弃最旧记录。

@ProviderFor(SportRecordLocalRepository)
final sportRecordLocalRepositoryProvider =
    SportRecordLocalRepositoryProvider._();

/// 运动记录本地存储仓库。
///
/// 基于 shared_preferences 实现，以 JSON 数组形式持久化运动记录。
/// 最多保留最近 [_maxRecords] 条（200 条），超出时自动丢弃最旧记录。
final class SportRecordLocalRepositoryProvider
    extends
        $NotifierProvider<
          SportRecordLocalRepository,
          SportRecordLocalRepository
        > {
  /// 运动记录本地存储仓库。
  ///
  /// 基于 shared_preferences 实现，以 JSON 数组形式持久化运动记录。
  /// 最多保留最近 [_maxRecords] 条（200 条），超出时自动丢弃最旧记录。
  SportRecordLocalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sportRecordLocalRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sportRecordLocalRepositoryHash();

  @$internal
  @override
  SportRecordLocalRepository create() => SportRecordLocalRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SportRecordLocalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SportRecordLocalRepository>(value),
    );
  }
}

String _$sportRecordLocalRepositoryHash() =>
    r'0e14018893f0358467a1b7936fe00f8f3e178f09';

/// 运动记录本地存储仓库。
///
/// 基于 shared_preferences 实现，以 JSON 数组形式持久化运动记录。
/// 最多保留最近 [_maxRecords] 条（200 条），超出时自动丢弃最旧记录。

abstract class _$SportRecordLocalRepository
    extends $Notifier<SportRecordLocalRepository> {
  SportRecordLocalRepository build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<SportRecordLocalRepository, SportRecordLocalRepository>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                SportRecordLocalRepository,
                SportRecordLocalRepository
              >,
              SportRecordLocalRepository,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
