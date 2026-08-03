import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 课程本地存储:路径解析 + 完整性校验 + 原子写。
///
/// **路径契约(1:1 兼容旧版)**:
/// - ZIP:    <docs>/course/zip/<imageName>.zip
/// - Voice:  <docs>/course/voice/<voiceName>.mp3
/// - BGM:    <docs>/course/bgm/<bgmName>.mp3
/// - 解压:   <docs>/course/actionImage/<imageName>/  (ZIP 内部结构保留)
///
/// **完整性增强**:
/// - 下载原子写:<file>.part → 成功后 rename 为正式名。
/// - 解压标记:actionImage/<imageName>/.complete(向后兼容旧版 background.png)。
class CourseLocalStorage {
  CourseLocalStorage({required Directory docsDir}) : _docsDir = docsDir;

  final Directory _docsDir;

  static Future<CourseLocalStorage> create() async {
    final docs = await getApplicationDocumentsDirectory();
    return CourseLocalStorage(docsDir: docs);
  }

  Directory get docsDir => _docsDir;
  String get courseRootPath => '${_docsDir.path}/course';
  String get actionImageRootPath => '$courseRootPath/actionImage';

  // ── 路径解析 ──
  String zipPath(String imageName) => '$courseRootPath/zip/$imageName.zip';
  String voicePath(String voiceName) => '$courseRootPath/voice/$voiceName.mp3';
  String bgmPath(String bgmName) => '$courseRootPath/bgm/$bgmName.mp3';
  String partPath(String formalPath) => '$formalPath.part';
  String completeMarkerPath(String imageName) =>
      '$actionImageRootPath/$imageName/.complete';
  String actionImageFramePath(String imageName, int frameIndex) =>
      '$actionImageRootPath/$imageName/$frameIndex.png';

  // ── 目录初始化(幂等)──
  Future<void> ensureCourseDirs() async {
    await Directory('$courseRootPath/zip').create(recursive: true);
    await Directory('$courseRootPath/voice').create(recursive: true);
    await Directory('$courseRootPath/bgm').create(recursive: true);
    await Directory(actionImageRootPath).create(recursive: true);
  }

  // ── 完整性 ──
  Future<bool> _isFileReady(String path) async {
    final f = File(path);
    if (!await f.exists()) return false;
    return (await f.length()) > 0;
  }

  Future<bool> isZipReady(String imageName) => _isFileReady(zipPath(imageName));
  Future<bool> isVoiceReady(String voiceName) =>
      _isFileReady(voicePath(voiceName));
  Future<bool> isBgmReady(String bgmName) => _isFileReady(bgmPath(bgmName));

  /// 已解压:.complete 标记 OR background.png 存在(向后兼容旧版)。
  Future<bool> isImageUnzipped(String imageName) async {
    if (await File(completeMarkerPath(imageName)).exists()) return true;
    return File('$actionImageRootPath/$imageName/background.png').existsSync();
  }

  // ── 原子写 ──
  Future<void> commitFile(String partPath, String formalPath) async {
    final part = File(partPath);
    if (!await part.exists()) {
      throw FileSystemException('part file not found', partPath);
    }
    final formal = File(formalPath);
    if (await formal.exists()) {
      await formal.delete();
    }
    await part.rename(formalPath);
  }

  /// 清理某正式路径对应的 .part 残留(失败/取消时调用)。
  Future<void> deletePartial(String formalPath) async {
    final part = File(partPath(formalPath));
    if (await part.exists()) {
      try {
        await part.delete();
      } catch (_) {}
    }
  }

  /// 写入解压完成标记(空文件)。
  Future<void> writeCompleteMarker(String imageName) async {
    await File(completeMarkerPath(imageName)).create(recursive: true);
  }
}
