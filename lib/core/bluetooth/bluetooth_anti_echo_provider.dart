import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'bluetooth_anti_echo.dart';

part 'bluetooth_anti_echo_provider.g.dart';

@Riverpod(keepAlive: true)
BluetoothAntiEcho bluetoothAntiEcho(Ref ref) {
  final antiEcho = BluetoothAntiEcho();
  ref.onDispose(antiEcho.reset);
  return antiEcho;
}
