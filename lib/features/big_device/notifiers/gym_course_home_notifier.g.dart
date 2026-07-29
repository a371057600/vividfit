// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_course_home_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GymCourseHomeNotifier)
final gymCourseHomeProvider = GymCourseHomeNotifierProvider._();

final class GymCourseHomeNotifierProvider
    extends $NotifierProvider<GymCourseHomeNotifier, GymCourseHomeState> {
  GymCourseHomeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymCourseHomeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymCourseHomeNotifierHash();

  @$internal
  @override
  GymCourseHomeNotifier create() => GymCourseHomeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymCourseHomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymCourseHomeState>(value),
    );
  }
}

String _$gymCourseHomeNotifierHash() =>
    r'87247d3da60a55ddba0c40b0e69f11a18a646edf';

abstract class _$GymCourseHomeNotifier extends $Notifier<GymCourseHomeState> {
  GymCourseHomeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GymCourseHomeState, GymCourseHomeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GymCourseHomeState, GymCourseHomeState>,
              GymCourseHomeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
