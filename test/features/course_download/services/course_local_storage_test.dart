import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/course_download/services/course_local_storage.dart';

void main() {
  late CourseLocalStorage storage;
  late Directory tmpRoot;

  setUp(() async {
    tmpRoot = await Directory.systemTemp.createTemp('cls_test_');
    // 直接注入 docsDir,无需 mock path_provider
    storage = CourseLocalStorage(docsDir: tmpRoot);
    await storage.ensureCourseDirs();
  });

  tearDown(() async {
    if (await tmpRoot.exists()) await tmpRoot.delete(recursive: true);
  });

  group('路径解析(1:1 兼容旧版)', () {
    test('zip/voice/bgm 路径', () {
      expect(storage.zipPath('img_a'), '${tmpRoot.path}/course/zip/img_a.zip');
      expect(storage.voicePath('voice_a'),
          '${tmpRoot.path}/course/voice/voice_a.mp3');
      expect(storage.bgmPath('bgm_a'), '${tmpRoot.path}/course/bgm/bgm_a.mp3');
    });
    test('解压根目录与帧图路径', () {
      expect(storage.actionImageRootPath, '${tmpRoot.path}/course/actionImage');
      expect(
        storage.actionImageFramePath('img_a', 42),
        '${tmpRoot.path}/course/actionImage/img_a/42.png',
      );
    });
    test('part 临时路径', () {
      expect(
        storage.partPath('${tmpRoot.path}/course/zip/a.zip'),
        '${tmpRoot.path}/course/zip/a.zip.part',
      );
    });
    test('complete 标记路径', () {
      expect(
        storage.completeMarkerPath('img_a'),
        '${tmpRoot.path}/course/actionImage/img_a/.complete',
      );
    });
  });

  group('完整性校验', () {
    test('不存在 → 未就绪', () async {
      expect(await storage.isZipReady('img_a'), isFalse);
    });
    test('零字节 → 未就绪', () async {
      await File(storage.zipPath('img_a')).create(recursive: true);
      expect(await storage.isZipReady('img_a'), isFalse);
    });
    test('非零字节 → 就绪', () async {
      await File(storage.zipPath('img_a')).writeAsBytes([1, 2, 3]);
      expect(await storage.isZipReady('img_a'), isTrue);
    });
    test('未解压 → false', () async {
      expect(await storage.isImageUnzipped('img_a'), isFalse);
    });
    test('.complete 标记存在 → true', () async {
      await File(storage.completeMarkerPath('img_a')).create(recursive: true);
      expect(await storage.isImageUnzipped('img_a'), isTrue);
    });
    test('向后兼容:background.png 存在 → true', () async {
      await File('${storage.actionImageRootPath}/img_a/background.png')
          .create(recursive: true);
      expect(await storage.isImageUnzipped('img_a'), isTrue);
    });
  });

  group('原子写', () {
    test('commitFile 把 .part 重命名为正式名', () async {
      final part = File('${storage.zipPath('img_a')}.part');
      await part.writeAsBytes([1, 2, 3]);
      await storage.commitFile(part.path, storage.zipPath('img_a'));
      expect(await File(storage.zipPath('img_a')).exists(), isTrue);
      expect(await part.exists(), isFalse);
    });
    test('commitFile 覆盖旧正式文件', () async {
      await File(storage.zipPath('img_a')).writeAsBytes([9]);
      final part = File('${storage.zipPath('img_a')}.part');
      await part.writeAsBytes([1, 2, 3]);
      await storage.commitFile(part.path, storage.zipPath('img_a'));
      expect(await File(storage.zipPath('img_a')).readAsBytes(), [1, 2, 3]);
    });
    test('deletePartial 清理 .part 残留', () async {
      final part = File('${storage.voicePath('v')}.part');
      await part.create(recursive: true);
      await storage.deletePartial(storage.voicePath('v'));
      expect(await part.exists(), isFalse);
    });
    test('deletePartial 不存在的 part 不抛错', () async {
      await storage.deletePartial(storage.voicePath('v'));
    });
  });

  group('ensureCourseDirs 幂等', () {
    test('重复调用不报错且目录存在', () async {
      await storage.ensureCourseDirs();
      await storage.ensureCourseDirs();
      expect(await Directory('${tmpRoot.path}/course/zip').exists(), isTrue);
      expect(await Directory('${tmpRoot.path}/course/voice').exists(), isTrue);
      expect(await Directory('${tmpRoot.path}/course/bgm').exists(), isTrue);
      expect(await Directory(storage.actionImageRootPath).exists(), isTrue);
    });
  });

  group('writeCompleteMarker', () {
    test('写入空文件', () async {
      await storage.writeCompleteMarker('img_a');
      final f = File(storage.completeMarkerPath('img_a'));
      expect(await f.exists(), isTrue);
      expect(await f.length(), 0);
    });
  });
}
