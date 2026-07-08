import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vividfit_v2/core/constants/storage_keys.dart';
import 'package:vividfit_v2/core/services/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StorageService', () {
    test('accessToken 读写', () async {
      final service = await StorageService.create();
      expect(service.accessToken, isNull);
      await service.setAccessToken('token_abc');
      expect(service.accessToken, 'token_abc');
    });

    test('userId 读写', () async {
      final service = await StorageService.create();
      expect(service.userId, isNull);
      await service.setUserId(12345);
      expect(service.userId, 12345);
    });

    test('userInfoJson 读写', () async {
      final service = await StorageService.create();
      expect(service.userInfoJson, isNull);
      await service.setUserInfoJson('{"id":1}');
      expect(service.userInfoJson, '{"id":1}');
    });

    test('hasPassword 读写', () async {
      final service = await StorageService.create();
      expect(service.hasPassword, isNull);
      await service.setHasPassword(true);
      expect(service.hasPassword, true);
    });

    test('headImageHash 读写', () async {
      final service = await StorageService.create();
      expect(service.headImageHash, isNull);
      await service.setHeadImageHash('hash_xxx');
      expect(service.headImageHash, 'hash_xxx');
    });

    test('clearAuth 清除全部登录数据', () async {
      final service = await StorageService.create();
      await service.setAccessToken('t');
      await service.setUserId(1);
      await service.setUserInfoJson('{}');
      await service.setHasPassword(true);
      await service.setHeadImageHash('h');

      await service.clearAuth();

      expect(service.accessToken, isNull);
      expect(service.userId, isNull);
      expect(service.userInfoJson, isNull);
      expect(service.hasPassword, isNull);
      expect(service.headImageHash, isNull);
    });

    test('键名与 StorageKeys 常量一致', () async {
      // 确保存储键名与常量定义一致,防止拼写漂移
      expect(StorageKeys.accessToken, 'AccessToken');
      expect(StorageKeys.userId, 'userId');
      expect(StorageKeys.userInfo, 'userInfo');
    });
  });
}
