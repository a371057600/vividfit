// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VipInfo _$VipInfoFromJson(Map<String, dynamic> json) => _VipInfo(
  userId: (json['userId'] as num?)?.toInt(),
  upgradeTime: json['upgradeTime'] as String?,
  expireTime: json['expireTime'] as String?,
  withinTheTerm: json['withinTheTerm'] as bool?,
);

Map<String, dynamic> _$VipInfoToJson(_VipInfo instance) => <String, dynamic>{
  'userId': instance.userId,
  'upgradeTime': instance.upgradeTime,
  'expireTime': instance.expireTime,
  'withinTheTerm': instance.withinTheTerm,
};
