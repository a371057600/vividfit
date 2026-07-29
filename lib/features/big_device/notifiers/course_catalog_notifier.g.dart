// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_catalog_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 课程目录 Notifier(Riverpod 3.0 代码生成)。
///
/// 1:1 迁移自旧 `BigCourseHomeController` 的课程列表相关逻辑,
/// 蓝牙部分不迁移。所有 JSON 请求通过 `CourseCatalogRepository`。

@ProviderFor(CourseCatalogNotifier)
final courseCatalogProvider = CourseCatalogNotifierProvider._();

/// 课程目录 Notifier(Riverpod 3.0 代码生成)。
///
/// 1:1 迁移自旧 `BigCourseHomeController` 的课程列表相关逻辑,
/// 蓝牙部分不迁移。所有 JSON 请求通过 `CourseCatalogRepository`。
final class CourseCatalogNotifierProvider
    extends $NotifierProvider<CourseCatalogNotifier, CourseCatalogState> {
  /// 课程目录 Notifier(Riverpod 3.0 代码生成)。
  ///
  /// 1:1 迁移自旧 `BigCourseHomeController` 的课程列表相关逻辑,
  /// 蓝牙部分不迁移。所有 JSON 请求通过 `CourseCatalogRepository`。
  CourseCatalogNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseCatalogNotifierHash();

  @$internal
  @override
  CourseCatalogNotifier create() => CourseCatalogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseCatalogState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseCatalogState>(value),
    );
  }
}

String _$courseCatalogNotifierHash() =>
    r'0036fb29696130730003b66ba1372843f972478c';

/// 课程目录 Notifier(Riverpod 3.0 代码生成)。
///
/// 1:1 迁移自旧 `BigCourseHomeController` 的课程列表相关逻辑,
/// 蓝牙部分不迁移。所有 JSON 请求通过 `CourseCatalogRepository`。

abstract class _$CourseCatalogNotifier extends $Notifier<CourseCatalogState> {
  CourseCatalogState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CourseCatalogState, CourseCatalogState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CourseCatalogState, CourseCatalogState>,
              CourseCatalogState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
