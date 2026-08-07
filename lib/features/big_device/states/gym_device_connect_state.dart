import 'package:freezed_annotation/freezed_annotation.dart';

part 'gym_device_connect_state.freezed.dart';

@freezed
abstract class GymDeviceConnectState with _$GymDeviceConnectState {
  const factory GymDeviceConnectState({
    /// 是否正在搜索(对应旧 searchStatus)。
    @Default(false) bool isSearching,

    /// Layer 1: 蓝牙链路是否已建立(对应旧 BluetoothConnectionState.connected)。
    /// 仅表示物理连接成功,不代表设备数据已就绪。
    @Default(false) bool isBluetoothConnected,

    /// Layer 2: 设备是否已完全就绪(对应旧 isDeviceConnect,需收到第一个 0x2ADA 数据包)。
    /// 用户可以安全使用设备功能的最终判定。
    @Default(false) bool isEquipmentConnected,

    /// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
    @Default(<String>[]) List<String> foundDeviceNames,

    /// 是否曾经连接过(对应旧 _hasConnected,用于断连 toast 抑制)。
    @Default(false) bool hasConnectedOnce,

    /// 是否正在连接中(防止重复点击)。
    @Default(false) bool isConnecting,
  }) = _GymDeviceConnectState;
}
