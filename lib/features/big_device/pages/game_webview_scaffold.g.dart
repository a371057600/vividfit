// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_webview_scaffold.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameRealsceneBridge)
final gameRealsceneBridgeProvider = GameRealsceneBridgeFamily._();

final class GameRealsceneBridgeProvider
    extends
        $FunctionalProvider<RealsceneBridge, RealsceneBridge, RealsceneBridge>
    with $Provider<RealsceneBridge> {
  GameRealsceneBridgeProvider._({
    required GameRealsceneBridgeFamily super.from,
    required ({FtmsDeviceType deviceType, int gameIndex}) super.argument,
  }) : super(
         retry: null,
         name: r'gameRealsceneBridgeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameRealsceneBridgeHash();

  @override
  String toString() {
    return r'gameRealsceneBridgeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<RealsceneBridge> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RealsceneBridge create(Ref ref) {
    final argument =
        this.argument as ({FtmsDeviceType deviceType, int gameIndex});
    return gameRealsceneBridge(
      ref,
      deviceType: argument.deviceType,
      gameIndex: argument.gameIndex,
    );
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
    return other is GameRealsceneBridgeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameRealsceneBridgeHash() =>
    r'5abe1565dfe261a64d1883916b028baf2ab71102';

final class GameRealsceneBridgeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          RealsceneBridge,
          ({FtmsDeviceType deviceType, int gameIndex})
        > {
  GameRealsceneBridgeFamily._()
    : super(
        retry: null,
        name: r'gameRealsceneBridgeProvider',
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
        isAutoDispose: true,
      );

  GameRealsceneBridgeProvider call({
    required FtmsDeviceType deviceType,
    required int gameIndex,
  }) => GameRealsceneBridgeProvider._(
    argument: (deviceType: deviceType, gameIndex: gameIndex),
    from: this,
  );

  @override
  String toString() => r'gameRealsceneBridgeProvider';
}
