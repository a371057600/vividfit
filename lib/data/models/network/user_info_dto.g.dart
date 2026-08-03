// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserInfoDto _$UserInfoDtoFromJson(Map<String, dynamic> json) => _UserInfoDto(
  id: (json['id'] as num?)?.toInt(),
  nickName: json['nickName'] as String?,
  birthday: json['birthday'] as String?,
  sex: json['sex'] as bool?,
  height: (json['height'] as num?)?.toInt(),
  weight: (json['weight'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserInfoDtoToJson(_UserInfoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'birthday': instance.birthday,
      'sex': instance.sex,
      'height': instance.height,
      'weight': instance.weight,
    };

_UserInfoResultDto _$UserInfoResultDtoFromJson(Map<String, dynamic> json) =>
    _UserInfoResultDto(
      userInfo: json['userInfo'] == null
          ? null
          : FitUserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
      thirdPartInfos: (json['thirdPartInfos'] as List<dynamic>?)
          ?.map((e) => ThirdPartyUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserInfoResultDtoToJson(_UserInfoResultDto instance) =>
    <String, dynamic>{
      'userInfo': instance.userInfo,
      'thirdPartInfos': instance.thirdPartInfos,
    };
