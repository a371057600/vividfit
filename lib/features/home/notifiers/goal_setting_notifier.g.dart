// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_setting_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoalSettingNotifier)
final goalSettingProvider = GoalSettingNotifierProvider._();

final class GoalSettingNotifierProvider
    extends $NotifierProvider<GoalSettingNotifier, GoalSettingState> {
  GoalSettingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalSettingNotifierHash();

  @$internal
  @override
  GoalSettingNotifier create() => GoalSettingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalSettingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalSettingState>(value),
    );
  }
}

String _$goalSettingNotifierHash() =>
    r'10dda3c38642db3ed992920e287b751466dfab45';

abstract class _$GoalSettingNotifier extends $Notifier<GoalSettingState> {
  GoalSettingState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GoalSettingState, GoalSettingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GoalSettingState, GoalSettingState>,
              GoalSettingState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
