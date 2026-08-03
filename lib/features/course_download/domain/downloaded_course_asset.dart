import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';

part 'downloaded_course_asset.freezed.dart';
part 'downloaded_course_asset.g.dart';

/// 登记表条目状态(与 DownloadProgress 的 status 区别:此处是持久化态)。
enum AssetStatus { downloading, ready, partial, corrupted }

/// 已下载图序列资产。
@freezed
abstract class ImageAsset with _$ImageAsset {
  const factory ImageAsset({
    required String imageName,
    @Default(0) int frameCount,
    @Default(0) int imageFps,
    @Default(0) int imageLength,
  }) = _ImageAsset;

  factory ImageAsset.fromJson(Map<String, dynamic> json) =>
      _$ImageAssetFromJson(json);
}

/// 已下载语音资产。
@freezed
abstract class VoiceAsset with _$VoiceAsset {
  const factory VoiceAsset({
    required String voiceName,
    String? dialect,
  }) = _VoiceAsset;

  factory VoiceAsset.fromJson(Map<String, dynamic> json) =>
      _$VoiceAssetFromJson(json);
}

/// 已下载 BGM 资产。
@freezed
abstract class BgmAsset with _$BgmAsset {
  const factory BgmAsset({required String bgmName}) = _BgmAsset;

  factory BgmAsset.fromJson(Map<String, dynamic> json) =>
      _$BgmAssetFromJson(json);
}

/// 登记表条目:某 (courseId, deviceType) 课程的离线化状态。
///
/// 复合键 = "${courseId}_${deviceType.name}"。
/// downloadDate 仅供审计展示,不参与查询(用户确认不按日期取用)。
@freezed
abstract class DownloadedCourseAsset with _$DownloadedCourseAsset {
  const DownloadedCourseAsset._();

  @JsonSerializable(explicitToJson: true)
  const factory DownloadedCourseAsset({
    required int courseId,
    required FtmsDeviceType deviceType,
    @Default(AssetStatus.downloading) AssetStatus status,
    @Default(0) int totalFiles,
    @Default(0) int completedFiles,
    @Default([]) List<ImageAsset> imageAssets,
    @Default([]) List<VoiceAsset> voiceAssets,
    @Default([]) List<BgmAsset> bgmAssets,
    String? downloadDate,
    @Default(1) int schemaVersion,
  }) = _DownloadedCourseAsset;

  factory DownloadedCourseAsset.fromJson(Map<String, dynamic> json) =>
      _$DownloadedCourseAssetFromJson(json);

  /// 复合键序列化(用 .name 不依赖 enum 顺序)。
  String get compositeKey => makeKey(courseId, deviceType);

  static String makeKey(int courseId, FtmsDeviceType deviceType) =>
      '${courseId}_${deviceType.name}';

  bool get isReady => status == AssetStatus.ready;
}
