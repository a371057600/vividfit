// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realscene_bridge.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(realsceneBridge)
final realsceneBridgeProvider = RealsceneBridgeFamily._();

final class RealsceneBridgeProvider
    extends
        $FunctionalProvider<RealsceneBridge, RealsceneBridge, RealsceneBridge>
    with $Provider<RealsceneBridge> {
  RealsceneBridgeProvider._({
    required RealsceneBridgeFamily super.from,
    required FtmsDeviceType super.argument,
  }) : super(
         retry: null,
         name: r'realsceneBridgeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$realsceneBridgeHash();

  @override
  String toString() {
    return r'realsceneBridgeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<RealsceneBridge> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RealsceneBridge create(Ref ref) {
    final argument = this.argument as FtmsDeviceType;
    return realsceneBridge(ref, deviceType: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RealsceneBridge value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RealsceneBridge>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RealsceneBridgeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$realsceneBridgeHash() => r'9a5de025c48a88ead376a11390cb77dc362335ec';

final class RealsceneBridgeFamily extends $Family
    with $FunctionalFamilyOverride<RealsceneBridge, FtmsDeviceType> {
  RealsceneBridgeFamily._()
    : super(
        retry: null,
        name: r'realsceneBridgeProvider',
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
        isAutoDispose: true,
      );

  RealsceneBridgeProvider call({required FtmsDeviceType deviceType}) =>
      RealsceneBridgeProvider._(argument: deviceType, from: this);

  @override
  String toString() => r'realsceneBridgeProvider';
}
