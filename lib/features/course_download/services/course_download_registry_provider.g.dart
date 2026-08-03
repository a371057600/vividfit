// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_download_registry_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全局单例(keepAlive)。
/// 复用项目 StorageService 持有的 SharedPreferences 实例。

@ProviderFor(courseDownloadRegistry)
final courseDownloadRegistryProvider = CourseDownloadRegistryProvider._();

/// 全局单例(keepAlive)。
/// 复用项目 StorageService 持有的 SharedPreferences 实例。

final class CourseDownloadRegistryProvider
    extends
        $FunctionalProvider<
          CourseDownloadRegistry,
          CourseDownloadRegistry,
          CourseDownloadRegistry
        >
    with $Provider<CourseDownloadRegistry> {
  /// 全局单例(keepAlive)。
  /// 复用项目 StorageService 持有的 SharedPreferences 实例。
  CourseDownloadRegistryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseDownloadRegistryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseDownloadRegistryHash();

  @$internal
  @override
  $ProviderElement<CourseDownloadRegistry> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CourseDownloadRegistry create(Ref ref) {
    return courseDownloadRegistry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseDownloadRegistry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseDownloadRegistry>(value),
    );
  }
}

String _$courseDownloadRegistryHash() =>
    r'37e3e9cd0ebb076cdb93041da924729f0efaa063';
