// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_detail_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository Provider(Riverpod 3.0 代码生成,keepAlive)。
/// 复用现有 `dioClientProvider`,不新建 Dio 实例。

@ProviderFor(courseDetailRepository)
final courseDetailRepositoryProvider = CourseDetailRepositoryProvider._();

/// Repository Provider(Riverpod 3.0 代码生成,keepAlive)。
/// 复用现有 `dioClientProvider`,不新建 Dio 实例。

final class CourseDetailRepositoryProvider
    extends
        $FunctionalProvider<
          CourseDetailRepository,
          CourseDetailRepository,
          CourseDetailRepository
        >
    with $Provider<CourseDetailRepository> {
  /// Repository Provider(Riverpod 3.0 代码生成,keepAlive)。
  /// 复用现有 `dioClientProvider`,不新建 Dio 实例。
  CourseDetailRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseDetailRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseDetailRepositoryHash();

  @$internal
  @override
  $ProviderElement<CourseDetailRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CourseDetailRepository create(Ref ref) {
    return courseDetailRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseDetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseDetailRepository>(value),
    );
  }
}

String _$courseDetailRepositoryHash() =>
    r'0137376539bfd1fa341aa270f02033330c26e0dd';
