import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/services/bluetooth_connection_service.dart';

void main() {
  group('BluetoothConnectionService', () {
    test('初始状态:targetDevice 为 null', () {
      final service = BluetoothConnectionService();
      expect(service.targetDevice, isNull);
    });

    test('onDevicesUpdated callback 被调用时传入设备名列表', () {
      final service = BluetoothConnectionService();
      List<String>? capturedNames;
      service.onDevicesUpdated = (names) => capturedNames = names;
      service.onDevicesUpdated!(['Device-A', 'Device-B']);
      expect(capturedNames, ['Device-A', 'Device-B']);
    });

    test('onConnectionChanged callback 传递连接状态', () {
      final service = BluetoothConnectionService();
      bool? capturedConnected;
      bool? capturedHasConnected;
      service.onConnectionChanged = (isConnected, hasConnectedOnce) {
        capturedConnected = isConnected;
        capturedHasConnected = hasConnectedOnce;
      };
      service.onConnectionChanged!(true, true);
      expect(capturedConnected, true);
      expect(capturedHasConnected, true);
    });

    test('onScanningChanged callback 传递搜索状态', () {
      final service = BluetoothConnectionService();
      bool? capturedScanning;
      service.onScanningChanged = (scanning) => capturedScanning = scanning;
      service.onScanningChanged!(true);
      expect(capturedScanning, true);
    });
  });
}
