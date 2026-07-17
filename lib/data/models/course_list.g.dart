// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseListImpl _$$CourseListImplFromJson(Map<String, dynamic> json) =>
    _$CourseListImpl(
      code: json['code'] as String?,
      data:
          json['data'] == null
              ? null
              : CourseListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CourseListImplToJson(_$CourseListImpl instance) =>
    <String, dynamic>{'code': instance.code, 'data': instance.data};

_$CourseListDataImpl _$$CourseListDataImplFromJson(Map<String, dynamic> json) =>
    _$CourseListDataImpl(
      dataList:
          (json['dataList'] as List<dynamic>?)
              ?.map((e) => CourseItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      currentPageNum: (json['currentPageNum'] as num?)?.toInt(),
      totalElements: (json['totalElements'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CourseListDataImplToJson(
  _$CourseListDataImpl instance,
) => <String, dynamic>{
  'dataList': instance.dataList,
  'currentPageNum': instance.currentPageNum,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
};

_$CourseItemImpl _$$CourseItemImplFromJson(Map<String, dynamic> json) =>
    _$CourseItemImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      cover: json['cover'] as String?,
      describe: json['describe'] as String?,
      proposal: json['proposal'] as String?,
      people: json['people'] as String?,
      carefulthing: json['carefulthing'] as String?,
      expectCalorie: (json['expectCalorie'] as num?)?.toInt(),
      during: (json['during'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      interactiveEquipment: (json['interactiveEquipment'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
      courseBgm: json['courseBgm'] as String?,
      version: (json['version'] as num?)?.toInt(),
      timing: json['timing'] as bool?,
      collect: json['collect'] as bool?,
    );

Map<String, dynamic> _$$CourseItemImplToJson(_$CourseItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover': instance.cover,
      'describe': instance.describe,
      'proposal': instance.proposal,
      'people': instance.people,
      'carefulthing': instance.carefulthing,
      'expectCalorie': instance.expectCalorie,
      'during': instance.during,
      'level': instance.level,
      'tags': instance.tags,
      'interactiveEquipment': instance.interactiveEquipment,
      'createTime': instance.createTime,
      'courseBgm': instance.courseBgm,
      'version': instance.version,
      'timing': instance.timing,
      'collect': instance.collect,
    };
