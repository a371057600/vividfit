// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedalMsg _$MedalMsgFromJson(Map<String, dynamic> json) => _MedalMsg(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  image: json['image'] as String?,
  describe: json['describe'] as String?,
  group: json['group'] as String?,
  target: (json['target'] as num?)?.toInt(),
  have: json['have'] as bool?,
  read: json['read'] as bool?,
  createTime: json['createTime'] as String?,
);

Map<String, dynamic> _$MedalMsgToJson(_MedalMsg instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
  'describe': instance.describe,
  'group': instance.group,
  'target': instance.target,
  'have': instance.have,
  'read': instance.read,
  'createTime': instance.createTime,
};

_MedalGroup _$MedalGroupFromJson(Map<String, dynamic> json) => _MedalGroup(
  groupName: json['groupName'] as String?,
  medals: (json['medals'] as List<dynamic>?)
      ?.map((e) => MedalMsg.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MedalGroupToJson(_MedalGroup instance) =>
    <String, dynamic>{
      'groupName': instance.groupName,
      'medals': instance.medals,
    };

_ReadMedal _$ReadMedalFromJson(Map<String, dynamic> json) => _ReadMedal(
  userId: (json['userId'] as num?)?.toInt(),
  medalIds: (json['medalIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$ReadMedalToJson(_ReadMedal instance) =>
    <String, dynamic>{'userId': instance.userId, 'medalIds': instance.medalIds};
