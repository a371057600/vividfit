import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_progress.freezed.dart';

enum DownloadStatus { idle, downloading, completed, failed, cancelled }

/// 下载进度聚合模型。
/// [overallProgress] = (completedFiles + currentFileProgress) / totalFiles,
/// 钳制到 [0.0, 1.0];totalFiles=0 返回 0 避免 NaN。
@freezed
abstract class DownloadProgress with _$DownloadProgress {
  const DownloadProgress._();

  const factory DownloadProgress({
    required int totalFiles,
    required int completedFiles,
    @Default(0.0) double currentFileProgress,
    String? currentFileName,
    required DownloadStatus status,
    String? errorReason,
  }) = _DownloadProgress;

  factory DownloadProgress.idle({required int totalFiles}) => DownloadProgress(
        totalFiles: totalFiles,
        completedFiles: 0,
        currentFileProgress: 0,
        currentFileName: null,
        status: DownloadStatus.idle,
      );

  factory DownloadProgress.downloading({
    required int totalFiles,
    required int completedFiles,
    required double currentFileProgress,
    String? currentFileName,
  }) =>
      DownloadProgress(
        totalFiles: totalFiles,
        completedFiles: completedFiles,
        currentFileProgress: currentFileProgress.clamp(0.0, 1.0),
        currentFileName: currentFileName,
        status: DownloadStatus.downloading,
      );

  factory DownloadProgress.completed({required int totalFiles}) => DownloadProgress(
        totalFiles: totalFiles,
        completedFiles: totalFiles,
        currentFileProgress: 1.0,
        currentFileName: null,
        status: DownloadStatus.completed,
      );

  factory DownloadProgress.failed({
    required int totalFiles,
    required int completedFiles,
    required String? fileName,
    required String reason,
  }) =>
      DownloadProgress(
        totalFiles: totalFiles,
        completedFiles: completedFiles,
        currentFileProgress: 0,
        currentFileName: fileName,
        status: DownloadStatus.failed,
        errorReason: reason,
      );

  factory DownloadProgress.cancelled({
    required int totalFiles,
    required int completedFiles,
  }) =>
      DownloadProgress(
        totalFiles: totalFiles,
        completedFiles: completedFiles,
        currentFileProgress: 0,
        currentFileName: null,
        status: DownloadStatus.cancelled,
      );

  double get overallProgress {
    if (totalFiles == 0) return 0.0;
    final raw = (completedFiles + currentFileProgress) / totalFiles;
    return raw.clamp(0.0, 1.0);
  }
}
