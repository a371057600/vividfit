// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'third_party_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThirdPartyUser _$ThirdPartyUserFromJson(Map<String, dynamic> json) =>
    _ThirdPartyUser(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      nickName: json['nickName'] as String?,
      headImgUrl: json['headImgUrl'] as String?,
      type: (json['type'] as num?)?.toInt(),
      openId: json['openId'] as String?,
      unionId: json['unionId'] as String?,
      province: json['province'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      sex: json['sex'] as bool?,
    );

Map<String, dynamic> _$ThirdPartyUserToJson(_ThirdPartyUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'nickName': instance.nickName,
      'headImgUrl': instance.headImgUrl,
      'type': instance.type,
      'openId': instance.openId,
      'unionId': instance.unionId,
      'province': instance.province,
      'city': instance.city,
      'country': instance.country,
      'sex': instance.sex,
    };
