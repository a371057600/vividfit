import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/features/course_download/domain/download_progress.dart';

void main() {
  group('DownloadProgress', () {
    test('idle 构造为 0 进度', () {
      final p = DownloadProgress.idle(totalFiles: 5);
      expect(p.overallProgress, 0.0);
      expect(p.completedFiles, 0);
      expect(p.totalFiles, 5);
      expect(p.status, DownloadStatus.idle);
    });

    test('downloading 聚合进度计算正确', () {
      final p = DownloadProgress.downloading(
        totalFiles: 4,
        completedFiles: 2,
        currentFileProgress: 0.5,
        currentFileName: 'voice_a.mp3',
      );
      // (2 + 0.5) / 4 = 0.625
      expect(p.overallProgress, 0.625);
      expect(p.status, DownloadStatus.downloading);
      expect(p.currentFileName, 'voice_a.mp3');
    });

    test('currentFileProgress 钳制到 [0,1]', () {
      final p = DownloadProgress.downloading(
        totalFiles: 2,
        completedFiles: 0,
        currentFileProgress: 1.5,
        currentFileName: 'x',
      );
      expect(p.currentFileProgress, 1.0);
    });

    test('totalFiles=0 不抛错,进度 0', () {
      final p = DownloadProgress.downloading(
        totalFiles: 0,
        completedFiles: 0,
        currentFileProgress: 0,
        currentFileName: null,
      );
      expect(p.overallProgress, 0.0);
    });

    test('completed 进度为 1', () {
      final p = DownloadProgress.completed(totalFiles: 3);
      expect(p.overallProgress, 1.0);
      expect(p.status, DownloadStatus.completed);
    });

    test('failed 携带原因与文件名', () {
      final p = DownloadProgress.failed(
        totalFiles: 3,
        completedFiles: 1,
        fileName: 'bgm_b.mp3',
        reason: 'network timeout',
      );
      expect(p.status, DownloadStatus.failed);
      expect(p.currentFileName, 'bgm_b.mp3');
      expect(p.errorReason, 'network timeout');
    });

    test('cancelled 状态', () {
      final p = DownloadProgress.cancelled(totalFiles: 3, completedFiles: 1);
      expect(p.status, DownloadStatus.cancelled);
      expect(p.completedFiles, 1);
    });
  });
}
