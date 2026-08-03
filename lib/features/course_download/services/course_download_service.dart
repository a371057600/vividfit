import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../domain/course_resource_manifest.dart';
import '../domain/download_progress.dart';
import 'course_local_storage.dart';

/// 课程下载服务:Dio 下载 + isolate 解压 + 单文件重试 + CancelToken 取消 + Stream 进度。
/// 纯 IO,不持有 Riverpod / BuildContext。
class CourseDownloadService {
  CourseDownloadService({
    required Dio dio,
    required CourseLocalStorage storage,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final CourseLocalStorage _storage;
  final int maxRetries;
  final Duration retryDelay;

  /// 下载整个清单。
  /// 按 imageZip → voice → bgm 顺序遍历,单文件指数退避重试 maxRetries 次。
  Stream<DownloadProgress> downloadManifest(
    CourseResourceManifest manifest, {
    CancelToken? cancelToken,
  }) async* {
    final all = <ResourceFile>[
      ...manifest.imageZips,
      ...manifest.voiceMp3s,
      ...manifest.bgmMp3s,
    ];
    final total = all.length;

    int completed = 0;
    for (final f in all) {
      if (await _isFileReady(f)) completed++;
    }
    print('🎯 [Manifest] totalFiles=$total skipped=$completed');

    yield DownloadProgress.downloading(
      totalFiles: total,
      completedFiles: completed,
      currentFileProgress: 0,
      currentFileName: null,
    );

    if (completed == total) {
      yield DownloadProgress.completed(totalFiles: total);
      return;
    }

    try {
      for (final file in all) {
        if (cancelToken?.isCancelled ?? false) {
          yield DownloadProgress.cancelled(
              totalFiles: total, completedFiles: completed);
          return;
        }
        if (await _isFileReady(file)) continue;

        final ok = await _downloadOneWithRetry(file, cancelToken);
        if (!ok) {
          if (cancelToken?.isCancelled ?? false) {
            yield DownloadProgress.cancelled(
                totalFiles: total, completedFiles: completed);
          } else {
            yield DownloadProgress.failed(
              totalFiles: total,
              completedFiles: completed,
              fileName: file.name,
              reason: '重试 $maxRetries 次后仍失败',
            );
            cancelToken?.cancel('manifest failed at ${file.name}');
          }
          return;
        }
        completed++;
        yield DownloadProgress.downloading(
          totalFiles: total,
          completedFiles: completed,
          currentFileProgress: 0,
          currentFileName: file.name,
        );
      }
      yield DownloadProgress.completed(totalFiles: total);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        yield DownloadProgress.cancelled(
            totalFiles: total, completedFiles: completed);
      } else {
        yield DownloadProgress.failed(
          totalFiles: total,
          completedFiles: completed,
          fileName: null,
          reason: e.message ?? e.toString(),
        );
      }
    }
  }

  Future<bool> _isFileReady(ResourceFile f) async {
    switch (f.type) {
      case ResourceType.imageZip:
        return _storage.isZipReady(f.name);
      case ResourceType.voiceMp3:
        return _storage.isVoiceReady(f.name);
      case ResourceType.bgmMp3:
        return _storage.isBgmReady(f.name);
    }
  }

  Future<bool> _downloadOneWithRetry(
    ResourceFile file,
    CancelToken? cancelToken,
  ) async {
    final formal = _formalPath(file);
    final part = _storage.partPath(formal);
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      if (cancelToken?.isCancelled ?? false) return false;
      try {
        print('📤 [Download] start file=${file.name} url=${file.url} '
            'savePath=$part attempt=$attempt');
        await _dio.download(
          file.url,
          part,
          onReceiveProgress: (received, total) {
            final pct = total == 0
                ? 0
                : (received / total * 100).toStringAsFixed(1);
            print('📊 [Download] progress file=${file.name} '
                'bytes=$received/$total pct=$pct%');
          },
          options: Options(receiveTimeout: const Duration(seconds: 60)),
          cancelToken: cancelToken,
          deleteOnError: true,
        );
        await _storage.commitFile(part, formal);
        print('✅ [Download] done file=${file.name}');
        return true;
      } catch (e) {
        print('♻️ [Download] retry file=${file.name} attempt=$attempt reason=$e');
        await _storage.deletePartial(formal);
        if (e is DioException && e.type == DioExceptionType.cancel) {
          return false;
        }
        if (attempt == maxRetries) {
          print('❌ [Download] failed file=${file.name} reason=$e');
          return false;
        }
        await Future.delayed(retryDelay * (1 << (attempt - 1)));
      }
    }
    return false;
  }

  String _formalPath(ResourceFile f) {
    switch (f.type) {
      case ResourceType.imageZip:
        return _storage.zipPath(f.name);
      case ResourceType.voiceMp3:
        return _storage.voicePath(f.name);
      case ResourceType.bgmMp3:
        return _storage.bgmPath(f.name);
    }
  }

  /// 解压清单的所有图序列 ZIP(isolate 内解压,避免阻塞 UI)。
  /// 已解压的跳过。并发上限 2。
  Future<void> unzipManifest(
    CourseResourceManifest manifest, {
    CancelToken? cancelToken,
  }) async {
    final pending = <ResourceFile>[];
    for (final f in manifest.imageZips) {
      if (await _storage.isImageUnzipped(f.name)) {
        print('📦 [Unzip] skip (already unzipped) imageName=${f.name}');
      } else {
        pending.add(f);
      }
    }
    final sem = _Semaphore(2);
    await Future.wait(pending.map((f) async {
      await sem.acquire();
      try {
        if (cancelToken?.isCancelled ?? false) return;
        await _unzipOne(f);
      } finally {
        sem.release();
      }
    }));
  }

  Future<void> _unzipOne(ResourceFile file) async {
    final zipPath = _storage.zipPath(file.name);
    final outDir = _storage.actionImageRootPath;
    print('📦 [Unzip] start imageName=${file.name} zip=$zipPath outDir=$outDir');
    final fileCount = await compute(
      _unzipIsolate,
      _UnzipPayload(zipPath: zipPath, outputDir: outDir),
    );
    await _storage.writeCompleteMarker(file.name);
    print('✅ [Unzip] done imageName=${file.name} files=$fileCount');
  }

  /// 清单是否全部就绪(文件齐 + 图解压)。
  Future<bool> isManifestReady(CourseResourceManifest manifest) async {
    for (final f in manifest.imageZips) {
      if (!await _storage.isZipReady(f.name)) return false;
      if (!await _storage.isImageUnzipped(f.name)) return false;
    }
    for (final f in manifest.voiceMp3s) {
      if (!await _storage.isVoiceReady(f.name)) return false;
    }
    for (final f in manifest.bgmMp3s) {
      if (!await _storage.isBgmReady(f.name)) return false;
    }
    return true;
  }
}

/// isolate 解压入口:读 zip 字节,解压,写文件,返回解出文件数。
int _unzipIsolate(_UnzipPayload payload) {
  final bytes = File(payload.zipPath).readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes);
  var count = 0;
  for (final file in archive) {
    final filePath = '${payload.outputDir}/${file.name}';
    if (file.isFile) {
      final data = file.content as List<int>;
      File(filePath).parent.createSync(recursive: true);
      File(filePath).writeAsBytesSync(data);
      count++;
    } else {
      Directory(filePath).createSync(recursive: true);
    }
  }
  return count;
}

class _UnzipPayload {
  const _UnzipPayload({required this.zipPath, required this.outputDir});
  final String zipPath;
  final String outputDir;
}

/// 简单计数信号量(无外部依赖)。
class _Semaphore {
  _Semaphore(this.maxPermits);
  final int maxPermits;
  int _taken = 0;
  final _waiters = <Completer<void>>[];

  Future<void> acquire() {
    if (_taken < maxPermits) {
      _taken++;
      return Future.value();
    }
    final c = Completer<void>();
    _waiters.add(c);
    return c.future;
  }

  void release() {
    if (_waiters.isEmpty) {
      _taken = (_taken - 1).clamp(0, maxPermits);
      return;
    }
    _waiters.removeAt(0).complete();
  }
}
