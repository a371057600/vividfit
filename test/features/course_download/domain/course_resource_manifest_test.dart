import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/course_download/domain/course_resource_manifest.dart';
import 'package:vividfit_v2/features/big_device/states/gym_course_detail_state.dart';

void main() {
  group('CourseResourceManifest', () {
    test('空 actionList 生成空清单', () {
      final m = CourseResourceManifest.fromActions(const []);
      expect(m.imageZips, isEmpty);
      expect(m.voiceMp3s, isEmpty);
      expect(m.bgmMp3s, isEmpty);
      expect(m.totalFileCount, 0);
    });

    test('按 name 去重(BGM 跨动作共享)', () {
      const actions = [
        CourseActionListItem(
          name: 'Warm Up',
          imageName: 'img_a',
          zipDownLoadPath: 'https://x/img_a.zip',
          voiceName: 'voice_a',
          voiceDownLoadPath: 'https://x/voice_a.mp3',
          bgmName: 'bgm_a',
          bgmDownLoadPath: 'https://x/bgm_a.mp3',
          isRestStage: false,
        ),
        CourseActionListItem(
          name: 'Sprint',
          imageName: 'img_b',
          zipDownLoadPath: 'https://x/img_b.zip',
          voiceName: 'voice_b',
          voiceDownLoadPath: 'https://x/voice_b.mp3',
          bgmName: 'bgm_a',
          bgmDownLoadPath: 'https://x/bgm_a.mp3',
          isRestStage: false,
        ),
      ];
      final m = CourseResourceManifest.fromActions(actions);
      expect(m.imageZips.length, 2);
      expect(m.voiceMp3s.length, 2);
      expect(m.bgmMp3s.length, 1);
      expect(m.totalFileCount, 5);
    });

    test('null path 或 null name 的字段被忽略', () {
      const actions = [
        CourseActionListItem(
          name: 'Rest',
          imageName: null,
          zipDownLoadPath: null,
          voiceName: null,
          voiceDownLoadPath: null,
          bgmName: null,
          bgmDownLoadPath: null,
          isRestStage: true,
        ),
        CourseActionListItem(
          name: 'Active',
          imageName: 'img_a',
          zipDownLoadPath: 'https://x/img_a.zip',
          voiceName: 'voice_a',
          voiceDownLoadPath: 'https://x/voice_a.mp3',
          bgmName: 'bgm_a',
          bgmDownLoadPath: 'https://x/bgm_a.mp3',
          isRestStage: false,
        ),
      ];
      final m = CourseResourceManifest.fromActions(actions);
      expect(m.totalFileCount, 3);
    });

    test('isRestStage=true 但有路径的项仍被包含(对齐旧版遍历全表)', () {
      const actions = [
        CourseActionListItem(
          name: 'Rest',
          imageName: 'img_rest',
          zipDownLoadPath: 'https://x/img_rest.zip',
          voiceName: 'voice_rest',
          voiceDownLoadPath: 'https://x/voice_rest.mp3',
          bgmName: 'bgm_rest',
          bgmDownLoadPath: 'https://x/bgm_rest.mp3',
          isRestStage: true,
        ),
      ];
      final m = CourseResourceManifest.fromActions(actions);
      expect(m.totalFileCount, 3);
    });
  });

  group('ResourceFile', () {
    test('字段不可变', () {
      const f = ResourceFile(
        name: 'a',
        url: 'https://x/a',
        type: ResourceType.imageZip,
      );
      expect(f.name, 'a');
      expect(f.type, ResourceType.imageZip);
    });
  });
}
