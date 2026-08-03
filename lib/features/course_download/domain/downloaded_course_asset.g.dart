// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_course_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageAsset _$ImageAssetFromJson(Map<String, dynamic> json) => _ImageAsset(
  imageName: json['imageName'] as String,
  frameCount: (json['frameCount'] as num?)?.toInt() ?? 0,
  imageFps: (json['imageFps'] as num?)?.toInt() ?? 0,
  imageLength: (json['imageLength'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ImageAssetToJson(_ImageAsset instance) =>
    <String, dynamic>{
      'imageName': instance.imageName,
      'frameCount': instance.frameCount,
      'imageFps': instance.imageFps,
      'imageLength': instance.imageLength,
    };

_VoiceAsset _$VoiceAssetFromJson(Map<String, dynamic> json) => _VoiceAsset(
  voiceName: json['voiceName'] as String,
  dialect: json['dialect'] as String?,
);

Map<String, dynamic> _$VoiceAssetToJson(_VoiceAsset instance) =>
    <String, dynamic>{
      'voiceName': instance.voiceName,
      'dialect': instance.dialect,
    };

_BgmAsset _$BgmAssetFromJson(Map<String, dynamic> json) =>
    _BgmAsset(bgmName: json['bgmName'] as String);

Map<String, dynamic> _$BgmAssetToJson(_BgmAsset instance) => <String, dynamic>{
  'bgmName': instance.bgmName,
};

_DownloadedCourseAsset _$DownloadedCourseAssetFromJson(
  Map<String, dynamic> json,
) => _DownloadedCourseAsset(
  courseId: (json['courseId'] as num).toInt(),
  deviceType: $enumDecode(_$FtmsDeviceTypeEnumMap, json['deviceType']),
  status:
      $enumDecodeNullable(_$AssetStatusEnumMap, json['status']) ??
      AssetStatus.downloading,
  totalFiles: (json['totalFiles'] as num?)?.toInt() ?? 0,
  completedFiles: (json['completedFiles'] as num?)?.toInt() ?? 0,
  imageAssets:
      (json['imageAssets'] as List<dynamic>?)
          ?.map((e) => ImageAsset.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  voiceAssets:
      (json['voiceAssets'] as List<dynamic>?)
          ?.map((e) => VoiceAsset.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  bgmAssets:
      (json['bgmAssets'] as List<dynamic>?)
          ?.map((e) => BgmAsset.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  downloadDate: json['downloadDate'] as String?,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$DownloadedCourseAssetToJson(
  _DownloadedCourseAsset instance,
) => <String, dynamic>{
  'courseId': instance.courseId,
  'deviceType': _$FtmsDeviceTypeEnumMap[instance.deviceType]!,
  'status': _$AssetStatusEnumMap[instance.status]!,
  'totalFiles': instance.totalFiles,
  'completedFiles': instance.completedFiles,
  'imageAssets': instance.imageAssets.map((e) => e.toJson()).toList(),
  'voiceAssets': instance.voiceAssets.map((e) => e.toJson()).toList(),
  'bgmAssets': instance.bgmAssets.map((e) => e.toJson()).toList(),
  'downloadDate': instance.downloadDate,
  'schemaVersion': instance.schemaVersion,
};

const _$FtmsDeviceTypeEnumMap = {
  FtmsDeviceType.indoorBike: 'indoorBike',
  FtmsDeviceType.treadmill: 'treadmill',
  FtmsDeviceType.crossTrainer: 'crossTrainer',
  FtmsDeviceType.rower: 'rower',
  FtmsDeviceType.strengthStation: 'strengthStation',
};

const _$AssetStatusEnumMap = {
  AssetStatus.downloading: 'downloading',
  AssetStatus.ready: 'ready',
  AssetStatus.partial: 'partial',
  AssetStatus.corrupted: 'corrupted',
};
