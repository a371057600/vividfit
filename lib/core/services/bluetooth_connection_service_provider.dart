import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'bluetooth_connection_service.dart';

part 'bluetooth_connection_service_provider.g.dart';

@Riverpod(keepAlive: true)
BluetoothConnectionService bluetoothConnectionService(Ref ref) {
  final service = BluetoothConnectionService();
  ref.onDispose(service.dispose);
  return service;
}
