// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CourseListNotifier)
final courseListProvider = CourseListNotifierProvider._();

final class CourseListNotifierProvider
    extends $NotifierProvider<CourseListNotifier, CourseListState> {
  CourseListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseListNotifierHash();

  @$internal
  @override
  CourseListNotifier create() => CourseListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseListState>(value),
    );
  }
}

String _$courseListNotifierHash() =>
    r'8587212e6413a43cbeee770fd79464ac3fa615ed';

abstract class _$CourseListNotifier extends $Notifier<CourseListState> {
  CourseListState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CourseListState, CourseListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CourseListState, CourseListState>,
              CourseListState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
