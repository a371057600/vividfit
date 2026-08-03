// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_download_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全局单例(keepAlive)。

@ProviderFor(courseDownloadService)
final courseDownloadServiceProvider = CourseDownloadServiceProvider._();

/// 全局单例(keepAlive)。

final class CourseDownloadServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<CourseDownloadService>,
          CourseDownloadService,
          FutureOr<CourseDownloadService>
        >
    with
        $FutureModifier<CourseDownloadService>,
        $FutureProvider<CourseDownloadService> {
  /// 全局单例(keepAlive)。
  CourseDownloadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseDownloadServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseDownloadServiceHash();

  @$internal
  @override
  $FutureProviderElement<CourseDownloadService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CourseDownloadService> create(Ref ref) {
    return courseDownloadService(ref);
  }
}

String _$courseDownloadServiceHash() =>
    r'60d03a1fcc2ab511bfad212524e856f0bcd80e4a';
