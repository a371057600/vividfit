// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSettingsNotifier)
final userSettingsProvider = UserSettingsNotifierProvider._();

final class UserSettingsNotifierProvider
    extends $NotifierProvider<UserSettingsNotifier, UserSettingsState> {
  UserSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSettingsNotifierHash();

  @$internal
  @override
  UserSettingsNotifier create() => UserSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserSettingsState>(value),
    );
  }
}

String _$userSettingsNotifierHash() =>
    r'3b48033e2adadee86f6d0657eed98e6556cd44c3';

abstract class _$UserSettingsNotifier extends $Notifier<UserSettingsState> {
  UserSettingsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UserSettingsState, UserSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserSettingsState, UserSettingsState>,
              UserSettingsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
