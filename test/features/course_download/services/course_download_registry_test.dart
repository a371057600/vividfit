import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vividfit_v2/core/ftms/ftms_device_type.dart';
import 'package:vividfit_v2/features/course_download/domain/downloaded_course_asset.dart';
import 'package:vividfit_v2/features/course_download/services/course_download_registry.dart';

void main() {
  late SharedPreferences prefs;
  late CourseDownloadRegistry registry;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    registry = CourseDownloadRegistry(prefs: prefs);
  });

  group('saveAsset / getAsset', () {
    test('未保存 → getAsset 返回 null', () async {
      expect(await registry.getAsset(7, FtmsDeviceType.indoorBike), isNull);
    });

    test('保存后能取回,字段不丢', () async {
      const a = DownloadedCourseAsset(
        courseId: 7,
        deviceType: FtmsDeviceType.indoorBike,
        status: AssetStatus.ready,
        totalFiles: 3,
        completedFiles: 3,
        imageAssets: [
          ImageAsset(
              imageName: 'img_a', frameCount: 30, imageFps: 30, imageLength: 30),
        ],
        voiceAssets: [VoiceAsset(voiceName: 'voice_a', dialect: 'chinese')],
        bgmAssets: [BgmAsset(bgmName: 'bgm_a')],
        downloadDate: '2026-08-03T10:00:00',
        schemaVersion: 1,
      );
      await registry.saveAsset(a);

      final got = await registry.getAsset(7, FtmsDeviceType.indoorBike);
      expect(got, isNotNull);
      expect(got!.courseId, 7);
      expect(got.deviceType, FtmsDeviceType.indoorBike);
      expect(got.status, AssetStatus.ready);
      expect(got.imageAssets.first.imageName, 'img_a');
      expect(got.voiceAssets.first.dialect, 'chinese');
      expect(got.bgmAssets.first.bgmName, 'bgm_a');
    });

    test('复合键隔离:同 courseId 不同 deviceType 互不干扰', () async {
      const bike = DownloadedCourseAsset(
        courseId: 5,
        deviceType: FtmsDeviceType.indoorBike,
        status: AssetStatus.ready,
        totalFiles: 1,
        completedFiles: 1,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03',
        schemaVersion: 1,
      );
      const treadmill = DownloadedCourseAsset(
        courseId: 5,
        deviceType: FtmsDeviceType.treadmill,
        status: AssetStatus.partial,
        totalFiles: 1,
        completedFiles: 0,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03',
        schemaVersion: 1,
      );
      await registry.saveAsset(bike);
      await registry.saveAsset(treadmill);

      expect(
          (await registry.getAsset(5, FtmsDeviceType.indoorBike))!.isReady, isTrue);
      expect(
          (await registry.getAsset(5, FtmsDeviceType.treadmill))!.isReady,
          isFalse);
    });
  });

  group('isReady', () {
    test('未登记 → false', () async {
      expect(await registry.isReady(7, FtmsDeviceType.indoorBike), isFalse);
    });
    test('登记 ready → true', () async {
      await registry.saveAsset(const DownloadedCourseAsset(
        courseId: 7,
        deviceType: FtmsDeviceType.indoorBike,
        status: AssetStatus.ready,
        totalFiles: 1,
        completedFiles: 1,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03',
        schemaVersion: 1,
      ));
      expect(await registry.isReady(7, FtmsDeviceType.indoorBike), isTrue);
    });
    test('登记 partial → false', () async {
      await registry.saveAsset(const DownloadedCourseAsset(
        courseId: 7,
        deviceType: FtmsDeviceType.indoorBike,
        status: AssetStatus.partial,
        totalFiles: 2,
        completedFiles: 1,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03',
        schemaVersion: 1,
      ));
      expect(await registry.isReady(7, FtmsDeviceType.indoorBike), isFalse);
    });
  });

  group('markPartial', () {
    test('写入 partial 态并保留素材清单', () async {
      // 先存 ready
      await registry.saveAsset(const DownloadedCourseAsset(
        courseId: 7,
        deviceType: FtmsDeviceType.indoorBike,
        status: AssetStatus.ready,
        totalFiles: 3,
        completedFiles: 3,
        imageAssets: [
          ImageAsset(
              imageName: 'img_a', frameCount: 30, imageFps: 30, imageLength: 30)
        ],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03',
        schemaVersion: 1,
      ));
      // 标记 partial
      await registry.markPartial(7, FtmsDeviceType.indoorBike, 1);
      final got = await registry.getAsset(7, FtmsDeviceType.indoorBike);
      expect(got!.status, AssetStatus.partial);
      expect(got.completedFiles, 1);
      expect(got.imageAssets, isNotEmpty); // 清单保留
    });
    test('未登记的 markPartial 自动创建条目', () async {
      await registry.markPartial(9, FtmsDeviceType.rower, 2);
      final got = await registry.getAsset(9, FtmsDeviceType.rower);
      expect(got, isNotNull);
      expect(got!.status, AssetStatus.partial);
      expect(got.completedFiles, 2);
    });
  });

  group('removeAsset', () {
    test('删除后 getAsset 返回 null', () async {
      await registry.saveAsset(const DownloadedCourseAsset(
        courseId: 7,
        deviceType: FtmsDeviceType.indoorBike,
        status: AssetStatus.ready,
        totalFiles: 1,
        completedFiles: 1,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03',
        schemaVersion: 1,
      ));
      await registry.removeAsset(7, FtmsDeviceType.indoorBike);
      expect(await registry.getAsset(7, FtmsDeviceType.indoorBike), isNull);
    });
    test('删除不存在的条目不抛错', () async {
      await registry.removeAsset(999, FtmsDeviceType.rower);
    });
  });

  group('listAll', () {
    test('返回所有已登记条目', () async {
      await registry.saveAsset(const DownloadedCourseAsset(
        courseId: 1,
        deviceType: FtmsDeviceType.indoorBike,
        status: AssetStatus.ready,
        totalFiles: 1,
        completedFiles: 1,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03',
        schemaVersion: 1,
      ));
      await registry.saveAsset(const DownloadedCourseAsset(
        courseId: 2,
        deviceType: FtmsDeviceType.treadmill,
        status: AssetStatus.ready,
        totalFiles: 1,
        completedFiles: 1,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03',
        schemaVersion: 1,
      ));
      final list = await registry.listAll();
      expect(list.length, 2);
    });
  });
}
