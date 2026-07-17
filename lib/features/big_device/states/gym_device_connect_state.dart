import 'package:freezed_annotation/freezed_annotation.dart';

part 'gym_device_connect_state.freezed.dart';

@freezed
class GymDeviceConnectState with _$GymDeviceConnectState {
  const factory GymDeviceConnectState({
    /// 是否正在搜索(对应旧 searchStatus)。
    @Default(false) bool isSearching,

    /// 设备是否已连接(对应旧 isDeviceConnect)。
    @Default(false) bool isEquipmentConnected,

    /// 已发现设备的广播名列表(对应旧 showDeviceName.map(advName))。
    @Default(<String>[]) List<String> foundDeviceNames,

    /// 是否曾经连接过(对应旧 _hasConnected,用于断连 toast 抑制)。
    @Default(false) bool hasConnectedOnce,
  }) = _GymDeviceConnectState;
}
