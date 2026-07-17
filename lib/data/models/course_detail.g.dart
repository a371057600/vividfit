// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseDetailImpl _$$CourseDetailImplFromJson(Map<String, dynamic> json) =>
    _$CourseDetailImpl(
      code: json['code'] as String?,
      msg: json['msg'] as String?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CourseAction.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$CourseDetailImplToJson(_$CourseDetailImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };

_$CourseActionImpl _$$CourseActionImplFromJson(Map<String, dynamic> json) =>
    _$CourseActionImpl(
      actionId: (json['actionId'] as num?)?.toInt(),
      actionType: (json['actionType'] as num?)?.toInt(),
      video: json['video'] as String?,
      cover: json['cover'] as String?,
      actionName: json['actionName'] as String?,
      actionVoice: json['actionVoice'] as String?,
      actionIntroduce: json['actionIntroduce'] as String?,
      actionIntroduceVoice: json['actionIntroduceVoice'] as String?,
      targetAmount: (json['targetAmount'] as num?)?.toInt(),
      during: (json['during'] as num?)?.toInt(),
      sets: (json['sets'] as num?)?.toInt(),
      speed: (json['speed'] as num?)?.toInt(),
      picturesList:
          json['picturesList'] == null
              ? null
              : ActionPictures.fromJson(
                json['picturesList'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$$CourseActionImplToJson(_$CourseActionImpl instance) =>
    <String, dynamic>{
      'actionId': instance.actionId,
      'actionType': instance.actionType,
      'video': instance.video,
      'cover': instance.cover,
      'actionName': instance.actionName,
      'actionVoice': instance.actionVoice,
      'actionIntroduce': instance.actionIntroduce,
      'actionIntroduceVoice': instance.actionIntroduceVoice,
      'targetAmount': instance.targetAmount,
      'during': instance.during,
      'sets': instance.sets,
      'speed': instance.speed,
      'picturesList': instance.picturesList,
    };

_$ActionPicturesImpl _$$ActionPicturesImplFromJson(Map<String, dynamic> json) =>
    _$ActionPicturesImpl(
      id: (json['id'] as num?)?.toInt(),
      actionId: (json['actionId'] as num?)?.toInt(),
      actionPictureName: json['actionPictureName'] as String?,
      actionPictureHash: json['actionPictureHash'] as String?,
    );

Map<String, dynamic> _$$ActionPicturesImplToJson(
  _$ActionPicturesImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'actionId': instance.actionId,
  'actionPictureName': instance.actionPictureName,
  'actionPictureHash': instance.actionPictureHash,
};
