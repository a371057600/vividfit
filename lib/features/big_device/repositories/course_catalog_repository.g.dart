// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_catalog_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository Provider(Riverpod 3.0 代码生成,keepAlive)。
/// 复用现有 `dioClientProvider`,不新建 Dio 实例。

@ProviderFor(courseCatalogRepository)
final courseCatalogRepositoryProvider = CourseCatalogRepositoryProvider._();

/// Repository Provider(Riverpod 3.0 代码生成,keepAlive)。
/// 复用现有 `dioClientProvider`,不新建 Dio 实例。

final class CourseCatalogRepositoryProvider
    extends
        $FunctionalProvider<
          CourseCatalogRepository,
          CourseCatalogRepository,
          CourseCatalogRepository
        >
    with $Provider<CourseCatalogRepository> {
  /// Repository Provider(Riverpod 3.0 代码生成,keepAlive)。
  /// 复用现有 `dioClientProvider`,不新建 Dio 实例。
  CourseCatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseCatalogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseCatalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CourseCatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CourseCatalogRepository create(Ref ref) {
    return courseCatalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseCatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseCatalogRepository>(value),
    );
  }
}

String _$courseCatalogRepositoryHash() =>
    r'c4fc0cbdece3362ac09fbda7cf8478dacdc1bfa5';
