import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'bluetooth_connection_service.dart';

part 'bluetooth_connection_service_provider.g.dart';

@riverpod
BluetoothConnectionService bluetoothConnectionService(Ref ref) {
  final service = BluetoothConnectionService();
  ref.onDispose(service.dispose);
  return service;
}
