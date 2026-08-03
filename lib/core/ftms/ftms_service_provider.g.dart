// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ftms_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 当前连接的 FTMS 服务(按设备类型创建)。
///
/// 依赖 [bluetoothConnectionServiceProvider] 提供 BluetoothDevice,
/// 调用方需先通过 [GymDeviceConnectNotifier] 完成蓝牙链路连接。
///
/// 当蓝牙设备连接成功时,此 Provider 自动创建对应设备类型的 FTMS 服务实例,
/// 并执行服务发现、特征值查找、数据/状态订阅。
///
/// 如果蓝牙未连接,返回 null。

@ProviderFor(ftmsService)
final ftmsServiceProvider = FtmsServiceFamily._();

/// 当前连接的 FTMS 服务(按设备类型创建)。
///
/// 依赖 [bluetoothConnectionServiceProvider] 提供 BluetoothDevice,
/// 调用方需先通过 [GymDeviceConnectNotifier] 完成蓝牙链路连接。
///
/// 当蓝牙设备连接成功时,此 Provider 自动创建对应设备类型的 FTMS 服务实例,
/// 并执行服务发现、特征值查找、数据/状态订阅。
///
/// 如果蓝牙未连接,返回 null。

final class FtmsServiceProvider
    extends
        $FunctionalProvider<
          FtmsServiceBase?,
          FtmsServiceBase?,
          FtmsServiceBase?
        >
    with $Provider<FtmsServiceBase?> {
  /// 当前连接的 FTMS 服务(按设备类型创建)。
  ///
  /// 依赖 [bluetoothConnectionServiceProvider] 提供 BluetoothDevice,
  /// 调用方需先通过 [GymDeviceConnectNotifier] 完成蓝牙链路连接。
  ///
  /// 当蓝牙设备连接成功时,此 Provider 自动创建对应设备类型的 FTMS 服务实例,
  /// 并执行服务发现、特征值查找、数据/状态订阅。
  ///
  /// 如果蓝牙未连接,返回 null。
  FtmsServiceProvider._({
    required FtmsServiceFamily super.from,
    required FtmsDeviceType super.argument,
  }) : super(
         retry: null,
         name: r'ftmsServiceProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ftmsServiceHash();

  @override
  String toString() {
    return r'ftmsServiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<FtmsServiceBase?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FtmsServiceBase? create(Ref ref) {
    final argument = this.argument as FtmsDeviceType;
    return ftmsService(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FtmsServiceBase? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FtmsServiceBase?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FtmsServiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ftmsServiceHash() => r'cfc8197aad105d19cc02ac338e619bdd71620056';

/// 当前连接的 FTMS 服务(按设备类型创建)。
///
/// 依赖 [bluetoothConnectionServiceProvider] 提供 BluetoothDevice,
/// 调用方需先通过 [GymDeviceConnectNotifier] 完成蓝牙链路连接。
///
/// 当蓝牙设备连接成功时,此 Provider 自动创建对应设备类型的 FTMS 服务实例,
/// 并执行服务发现、特征值查找、数据/状态订阅。
///
/// 如果蓝牙未连接,返回 null。

final class FtmsServiceFamily extends $Family
    with $FunctionalFamilyOverride<FtmsServiceBase?, FtmsDeviceType> {
  FtmsServiceFamily._()
    : super(
        retry: null,
        name: r'ftmsServiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 当前连接的 FTMS 服务(按设备类型创建)。
  ///
  /// 依赖 [bluetoothConnectionServiceProvider] 提供 BluetoothDevice,
  /// 调用方需先通过 [GymDeviceConnectNotifier] 完成蓝牙链路连接。
  ///
  /// 当蓝牙设备连接成功时,此 Provider 自动创建对应设备类型的 FTMS 服务实例,
  /// 并执行服务发现、特征值查找、数据/状态订阅。
  ///
  /// 如果蓝牙未连接,返回 null。

  FtmsServiceProvider call(FtmsDeviceType deviceType) =>
      FtmsServiceProvider._(argument: deviceType, from: this);

  @override
  String toString() => r'ftmsServiceProvider';
}
