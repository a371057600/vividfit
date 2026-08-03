import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/core/ftms/ftms_device_type.dart';
import 'package:vividfit_v2/features/course_download/domain/downloaded_course_asset.dart';

void main() {
  group('DownloadedCourseAsset', () {
    test('复合键 = courseId_deviceType.name', () {
      const a = DownloadedCourseAsset(
        courseId: 7,
        deviceType: FtmsDeviceType.indoorBike,
        status: AssetStatus.ready,
        totalFiles: 3,
        completedFiles: 3,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03T10:00:00',
        schemaVersion: 1,
      );
      expect(a.compositeKey, '7_indoorBike');
    });

    test('isReady 判断', () {
      const ready = DownloadedCourseAsset(
        courseId: 1,
        deviceType: FtmsDeviceType.treadmill,
        status: AssetStatus.ready,
        totalFiles: 2,
        completedFiles: 2,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03T10:00:00',
        schemaVersion: 1,
      );
      const partial = DownloadedCourseAsset(
        courseId: 1,
        deviceType: FtmsDeviceType.treadmill,
        status: AssetStatus.partial,
        totalFiles: 2,
        completedFiles: 1,
        imageAssets: [],
        voiceAssets: [],
        bgmAssets: [],
        downloadDate: '2026-08-03T10:00:00',
        schemaVersion: 1,
      );
      expect(ready.isReady, isTrue);
      expect(partial.isReady, isFalse);
    });

    test('JSON 往返不丢字段', () {
      const a = DownloadedCourseAsset(
        courseId: 5,
        deviceType: FtmsDeviceType.crossTrainer,
        status: AssetStatus.ready,
        totalFiles: 3,
        completedFiles: 3,
        imageAssets: [
          ImageAsset(
            imageName: 'img_a',
            frameCount: 30,
            imageFps: 30,
            imageLength: 30,
          ),
        ],
        voiceAssets: [VoiceAsset(voiceName: 'voice_a', dialect: 'chinese')],
        bgmAssets: [BgmAsset(bgmName: 'bgm_a')],
        downloadDate: '2026-08-03T10:00:00',
        schemaVersion: 1,
      );
      final json = a.toJson();
      final restored = DownloadedCourseAsset.fromJson(json);
      expect(restored.courseId, 5);
      expect(restored.deviceType, FtmsDeviceType.crossTrainer);
      expect(restored.status, AssetStatus.ready);
      expect(restored.imageAssets.first.imageName, 'img_a');
      expect(restored.voiceAssets.first.dialect, 'chinese');
      expect(restored.bgmAssets.first.bgmName, 'bgm_a');
      expect(restored.compositeKey, '5_crossTrainer');
    });

    test('makeKey 静态方法与实例 compositeKey 一致', () {
      expect(
        DownloadedCourseAsset.makeKey(7, FtmsDeviceType.indoorBike),
        '7_indoorBike',
      );
    });
  });
}
