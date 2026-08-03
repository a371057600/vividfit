// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_local_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全局单例(keepAlive)。
/// 用 FutureProvider 因依赖 getApplicationDocumentsDirectory 异步。

@ProviderFor(courseLocalStorage)
final courseLocalStorageProvider = CourseLocalStorageProvider._();

/// 全局单例(keepAlive)。
/// 用 FutureProvider 因依赖 getApplicationDocumentsDirectory 异步。

final class CourseLocalStorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<CourseLocalStorage>,
          CourseLocalStorage,
          FutureOr<CourseLocalStorage>
        >
    with
        $FutureModifier<CourseLocalStorage>,
        $FutureProvider<CourseLocalStorage> {
  /// 全局单例(keepAlive)。
  /// 用 FutureProvider 因依赖 getApplicationDocumentsDirectory 异步。
  CourseLocalStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseLocalStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseLocalStorageHash();

  @$internal
  @override
  $FutureProviderElement<CourseLocalStorage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CourseLocalStorage> create(Ref ref) {
    return courseLocalStorage(ref);
  }
}

String _$courseLocalStorageHash() =>
    r'acd1582839d725783d091fd59538e334296a6d7e';
