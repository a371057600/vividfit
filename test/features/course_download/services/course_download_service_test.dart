import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vividfit_v2/features/course_download/domain/course_resource_manifest.dart';
import 'package:vividfit_v2/features/course_download/domain/download_progress.dart';
import 'package:vividfit_v2/features/course_download/services/course_download_service.dart';
import 'package:vividfit_v2/features/course_download/services/course_local_storage.dart';

class _MockStorage extends Mock implements CourseLocalStorage {}
class _MockDio extends Mock implements Dio {}

void main() {
  late _MockStorage storage;
  late _MockDio dio;
  late CourseDownloadService svc;
  late Directory tmp;

  setUp(() async {
    storage = _MockStorage();
    dio = _MockDio();
    tmp = await Directory.systemTemp.createTemp('cds_test_');
    svc = CourseDownloadService(
      dio: dio,
      storage: storage,
      retryDelay: Duration.zero,
    );
    registerFallbackValue(Options());
    registerFallbackValue(CancelToken());
  });

  tearDown(() async {
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  group('downloadManifest', () {
    test('全部已就绪 → 直接 emit completed,不发起网络请求', () async {
      const manifest = CourseResourceManifest(
        imageZips: [
          ResourceFile(
              name: 'a', url: 'https://x/a.zip', type: ResourceType.imageZip)
        ],
        voiceMp3s: [
          ResourceFile(
              name: 'v', url: 'https://x/v.mp3', type: ResourceType.voiceMp3)
        ],
        bgmMp3s: [],
      );
      when(() => storage.isZipReady('a')).thenAnswer((_) async => true);
      when(() => storage.isVoiceReady('v')).thenAnswer((_) async => true);
      when(() => storage.zipPath('a')).thenReturn('${tmp.path}/a.zip');
      when(() => storage.voicePath('v')).thenReturn('${tmp.path}/v.mp3');
      when(() => storage.partPath(any())).thenReturn('${tmp.path}/a.zip.part');

      final events = await svc.downloadManifest(manifest).toList();

      verifyNever(() => dio.download(any(), any(),
          onReceiveProgress: any(named: 'onReceiveProgress'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          deleteOnError: any(named: 'deleteOnError')));
      expect(events.last.status, DownloadStatus.completed);
      expect(events.last.overallProgress, 1.0);
      expect(events.last.completedFiles, 2);
    });

    test('单文件下载成功 → 流式进度 → completed', () async {
      const manifest = CourseResourceManifest(
        imageZips: [
          ResourceFile(
              name: 'a', url: 'https://x/a.zip', type: ResourceType.imageZip)
        ],
        voiceMp3s: [],
        bgmMp3s: [],
      );
      when(() => storage.isZipReady('a')).thenAnswer((_) async => false);
      when(() => storage.zipPath('a')).thenReturn('${tmp.path}/a.zip');
      when(() => storage.partPath('${tmp.path}/a.zip'))
          .thenReturn('${tmp.path}/a.zip.part');
      when(() => dio.download(
            any(),
            any(),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            deleteOnError: any(named: 'deleteOnError'),
          )).thenAnswer((inv) async {
        final cb = inv.namedArguments[#onReceiveProgress] as ProgressCallback?;
        final savePath = inv.positionalArguments[1] as String;
        await File(savePath).writeAsBytes(Uint8List.fromList([1, 2, 3, 4]));
        cb?.call(2, 4);
        cb?.call(4, 4);
        return Response<dynamic>(
          requestOptions: RequestOptions(path: 'https://x/a.zip'),
          statusCode: 200,
        );
      });
      when(() => storage.commitFile(any(), any())).thenAnswer((inv) async {
        await File(inv.positionalArguments[0] as String)
            .rename(inv.positionalArguments[1] as String);
      });

      final events = await svc.downloadManifest(manifest).toList();

      expect(events.last.status, DownloadStatus.completed);
      expect(events.last.overallProgress, 1.0);
      expect(await File('${tmp.path}/a.zip').exists(), isTrue);
    });

    test('重试 N 次仍失败 → emit failed', () async {
      const manifest = CourseResourceManifest(
        imageZips: [
          ResourceFile(
              name: 'a', url: 'https://x/a.zip', type: ResourceType.imageZip)
        ],
        voiceMp3s: [],
        bgmMp3s: [],
      );
      when(() => storage.isZipReady('a')).thenAnswer((_) async => false);
      when(() => storage.zipPath('a')).thenReturn('${tmp.path}/a.zip');
      when(() => storage.partPath(any())).thenReturn('${tmp.path}/a.zip.part');
      when(() => storage.deletePartial(any())).thenAnswer((_) async {});
      when(() => dio.download(
            any(),
            any(),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            deleteOnError: any(named: 'deleteOnError'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: 'https://x/a.zip'),
        type: DioExceptionType.connectionTimeout,
        message: 'timeout',
      ));

      final events = await svc.downloadManifest(manifest).toList();

      expect(events.last.status, DownloadStatus.failed);
      expect(events.last.currentFileName, 'a');
      expect(events.last.errorReason, contains('重试'));
      verify(() => storage.deletePartial(any()))
          .called(greaterThanOrEqualTo(1));
    });

    test('cancelToken 取消 → emit cancelled', () async {
      const manifest = CourseResourceManifest(
        imageZips: [
          ResourceFile(
              name: 'a', url: 'https://x/a.zip', type: ResourceType.imageZip)
        ],
        voiceMp3s: [],
        bgmMp3s: [],
      );
      final cancelToken = CancelToken();
      when(() => storage.isZipReady('a')).thenAnswer((_) async => false);
      when(() => storage.zipPath('a')).thenReturn('${tmp.path}/a.zip');
      when(() => storage.partPath(any())).thenReturn('${tmp.path}/a.zip.part');
      when(() => storage.deletePartial(any())).thenAnswer((_) async {});
      when(() => dio.download(
            any(),
            any(),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            deleteOnError: any(named: 'deleteOnError'),
          )).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        throw DioException(
          requestOptions: RequestOptions(path: 'https://x/a.zip'),
          type: DioExceptionType.cancel,
          message: 'cancelled',
        );
      });

      Future.delayed(const Duration(milliseconds: 10), cancelToken.cancel);

      final events = await svc
          .downloadManifest(manifest, cancelToken: cancelToken)
          .toList();

      expect(events.last.status, DownloadStatus.cancelled);
    });
  });

  group('unzipManifest', () {
    test('未解压的 zip 被解压并写标记', () async {
      final archive = Archive()
        ..addFile(ArchiveFile('img_a/background.png', 3, [1, 2, 3]))
        ..addFile(ArchiveFile('img_a/0.png', 2, [9, 9]));
      final zipBytes = ZipEncoder().encode(archive)!;
      final zipPath = '${tmp.path}/img_a.zip';
      await File(zipPath).writeAsBytes(zipBytes);

      const manifest = CourseResourceManifest(
        imageZips: [
          ResourceFile(
              name: 'img_a',
              url: 'https://x/img_a.zip',
              type: ResourceType.imageZip)
        ],
        voiceMp3s: [],
        bgmMp3s: [],
      );
      when(() => storage.isImageUnzipped('img_a'))
          .thenAnswer((_) async => false);
      when(() => storage.zipPath('img_a')).thenReturn(zipPath);
      when(() => storage.actionImageRootPath)
          .thenReturn('${tmp.path}/actionImage');
      when(() => storage.completeMarkerPath('img_a'))
          .thenReturn('${tmp.path}/actionImage/img_a/.complete');
      when(() => storage.writeCompleteMarker('img_a')).thenAnswer((_) async {
        await File('${tmp.path}/actionImage/img_a/.complete')
            .create(recursive: true);
      });

      await svc.unzipManifest(manifest);

      expect(
          await File('${tmp.path}/actionImage/img_a/background.png').exists(),
          isTrue);
      expect(await File('${tmp.path}/actionImage/img_a/0.png').exists(),
          isTrue);
      expect(
          await File('${tmp.path}/actionImage/img_a/.complete').exists(),
          isTrue);
    });

    test('已解压的 zip 跳过', () async {
      const manifest = CourseResourceManifest(
        imageZips: [
          ResourceFile(
              name: 'img_a',
              url: 'https://x/img_a.zip',
              type: ResourceType.imageZip)
        ],
        voiceMp3s: [],
        bgmMp3s: [],
      );
      when(() => storage.isImageUnzipped('img_a'))
          .thenAnswer((_) async => true);

      await svc.unzipManifest(manifest);

      verifyNever(() => storage.zipPath(any()));
      verifyNever(() => storage.writeCompleteMarker(any()));
    });
  });

  group('isManifestReady', () {
    test('全部就绪 + 全部解压 → true', () async {
      const manifest = CourseResourceManifest(
        imageZips: [
          ResourceFile(
              name: 'a', url: 'u', type: ResourceType.imageZip)
        ],
        voiceMp3s: [
          ResourceFile(
              name: 'v', url: 'u', type: ResourceType.voiceMp3)
        ],
        bgmMp3s: [
          ResourceFile(
              name: 'b', url: 'u', type: ResourceType.bgmMp3)
        ],
      );
      when(() => storage.isZipReady('a')).thenAnswer((_) async => true);
      when(() => storage.isVoiceReady('v')).thenAnswer((_) async => true);
      when(() => storage.isBgmReady('b')).thenAnswer((_) async => true);
      when(() => storage.isImageUnzipped('a')).thenAnswer((_) async => true);

      expect(await svc.isManifestReady(manifest), isTrue);
    });

    test('任一缺失 → false', () async {
      const manifest = CourseResourceManifest(
        imageZips: [
          ResourceFile(
              name: 'a', url: 'u', type: ResourceType.imageZip)
        ],
        voiceMp3s: [],
        bgmMp3s: [],
      );
      when(() => storage.isZipReady('a')).thenAnswer((_) async => true);
      when(() => storage.isImageUnzipped('a')).thenAnswer((_) async => false);

      expect(await svc.isManifestReady(manifest), isFalse);
    });
  });
}
