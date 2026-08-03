// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_anti_echo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bluetoothAntiEcho)
final bluetoothAntiEchoProvider = BluetoothAntiEchoProvider._();

final class BluetoothAntiEchoProvider
    extends
        $FunctionalProvider<
          BluetoothAntiEcho,
          BluetoothAntiEcho,
          BluetoothAntiEcho
        >
    with $Provider<BluetoothAntiEcho> {
  BluetoothAntiEchoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bluetoothAntiEchoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bluetoothAntiEchoHash();

  @$internal
  @override
  $ProviderElement<BluetoothAntiEcho> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BluetoothAntiEcho create(Ref ref) {
    return bluetoothAntiEcho(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BluetoothAntiEcho value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BluetoothAntiEcho>(value),
    );
  }
}

String _$bluetoothAntiEchoHash() => r'3239816d755ac8311ada091081dbb7a25b073341';
