// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_connection_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bluetoothConnectionService)
final bluetoothConnectionServiceProvider =
    BluetoothConnectionServiceProvider._();

final class BluetoothConnectionServiceProvider
    extends
        $FunctionalProvider<
          BluetoothConnectionService,
          BluetoothConnectionService,
          BluetoothConnectionService
        >
    with $Provider<BluetoothConnectionService> {
  BluetoothConnectionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bluetoothConnectionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bluetoothConnectionServiceHash();

  @$internal
  @override
  $ProviderElement<BluetoothConnectionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BluetoothConnectionService create(Ref ref) {
    return bluetoothConnectionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BluetoothConnectionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BluetoothConnectionService>(value),
    );
  }
}

String _$bluetoothConnectionServiceHash() =>
    r'8c499a0254f6b933dec7ea913c01ea2168b5ae34';
