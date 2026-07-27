import 'package:riverpod/riverpod.dart';

import 'bluetooth_connection_service.dart';

final bluetoothConnectionServiceProvider = Provider<BluetoothConnectionService>((ref) {
  final service = BluetoothConnectionService();
  ref.onDispose(service.dispose);
  return service;
});