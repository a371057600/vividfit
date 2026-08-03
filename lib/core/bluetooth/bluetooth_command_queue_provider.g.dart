// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_command_queue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bluetoothCommandQueue)
final bluetoothCommandQueueProvider = BluetoothCommandQueueFamily._();

final class BluetoothCommandQueueProvider
    extends
        $FunctionalProvider<
          BluetoothCommandQueue?,
          BluetoothCommandQueue?,
          BluetoothCommandQueue?
        >
    with $Provider<BluetoothCommandQueue?> {
  BluetoothCommandQueueProvider._({
    required BluetoothCommandQueueFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'bluetoothCommandQueueProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bluetoothCommandQueueHash();

  @override
  String toString() {
    return r'bluetoothCommandQueueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<BluetoothCommandQueue?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BluetoothCommandQueue? create(Ref ref) {
    final argument = this.argument as int;
    return bluetoothCommandQueue(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BluetoothCommandQueue? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BluetoothCommandQueue?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BluetoothCommandQueueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bluetoothCommandQueueHash() =>
    r'7a0710936c337552219664147525fc3119fe5604';

final class BluetoothCommandQueueFamily extends $Family
    with $FunctionalFamilyOverride<BluetoothCommandQueue?, int> {
  BluetoothCommandQueueFamily._()
    : super(
        retry: null,
        name: r'bluetoothCommandQueueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  BluetoothCommandQueueProvider call(int deviceCategoryIndex) =>
      BluetoothCommandQueueProvider._(
        argument: deviceCategoryIndex,
        from: this,
      );

  @override
  String toString() => r'bluetoothCommandQueueProvider';
}
