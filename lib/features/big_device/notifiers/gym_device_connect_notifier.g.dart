// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_device_connect_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GymDeviceConnectNotifier)
final gymDeviceConnectProvider = GymDeviceConnectNotifierProvider._();

final class GymDeviceConnectNotifierProvider
    extends $NotifierProvider<GymDeviceConnectNotifier, GymDeviceConnectState> {
  GymDeviceConnectNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymDeviceConnectProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymDeviceConnectNotifierHash();

  @$internal
  @override
  GymDeviceConnectNotifier create() => GymDeviceConnectNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymDeviceConnectState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymDeviceConnectState>(value),
    );
  }
}

String _$gymDeviceConnectNotifierHash() =>
    r'3dcddef48ebc876e4ca71fc9431c579bc3ee1f9d';

abstract class _$GymDeviceConnectNotifier
    extends $Notifier<GymDeviceConnectState> {
  GymDeviceConnectState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GymDeviceConnectState, GymDeviceConnectState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GymDeviceConnectState, GymDeviceConnectState>,
              GymDeviceConnectState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
