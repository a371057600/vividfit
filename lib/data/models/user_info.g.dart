// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FitUserInfo _$FitUserInfoFromJson(Map<String, dynamic> json) => _FitUserInfo(
  id: (json['id'] as num?)?.toInt(),
  nickName: json['nickName'] as String?,
  sex: json['sex'] as bool?,
  birthday: json['birthday'] as String?,
  height: (json['height'] as num?)?.toInt(),
  weight: (json['weight'] as num?)?.toInt(),
  headImage: json['headImage'] as String?,
  mailAddress: json['mailAddress'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  phoneArea: json['phoneArea'] as String?,
  createTime: json['createTime'] as String?,
  disabled: json['disabled'] as bool?,
  hasPsw: json['hasPsw'] as bool?,
);

Map<String, dynamic> _$FitUserInfoToJson(_FitUserInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'sex': instance.sex,
      'birthday': instance.birthday,
      'height': instance.height,
      'weight': instance.weight,
      'headImage': instance.headImage,
      'mailAddress': instance.mailAddress,
      'phoneNumber': instance.phoneNumber,
      'phoneArea': instance.phoneArea,
      'createTime': instance.createTime,
      'disabled': instance.disabled,
      'hasPsw': instance.hasPsw,
    };
