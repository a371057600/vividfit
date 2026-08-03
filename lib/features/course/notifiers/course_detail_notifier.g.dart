// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CourseDetailNotifier)
final courseDetailProvider = CourseDetailNotifierProvider._();

final class CourseDetailNotifierProvider
    extends $NotifierProvider<CourseDetailNotifier, CourseDetailState> {
  CourseDetailNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseDetailProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseDetailNotifierHash();

  @$internal
  @override
  CourseDetailNotifier create() => CourseDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseDetailState>(value),
    );
  }
}

String _$courseDetailNotifierHash() =>
    r'ace9a0c7deb63f284909912aea0efb828731d986';

abstract class _$CourseDetailNotifier extends $Notifier<CourseDetailState> {
  CourseDetailState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CourseDetailState, CourseDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CourseDetailState, CourseDetailState>,
              CourseDetailState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
