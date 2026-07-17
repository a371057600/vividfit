import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_list.freezed.dart';
part 'course_list.g.dart';

@freezed
class CourseList with _$CourseList {
  const factory CourseList({
    String? code,
    CourseListData? data,
  }) = _CourseList;

  factory CourseList.fromJson(Map<String, dynamic> json) =>
      _$CourseListFromJson(json);
}

@freezed
class CourseListData with _$CourseListData {
  const factory CourseListData({
    List<CourseItem>? dataList,
    int? currentPageNum,
    int? totalElements,
    int? totalPages,
  }) = _CourseListData;

  factory CourseListData.fromJson(Map<String, dynamic> json) =>
      _$CourseListDataFromJson(json);
}

@freezed
class CourseItem with _$CourseItem {
  const factory CourseItem({
    int? id,
    String? title,
    String? cover,
    String? describe,
    String? proposal,
    String? people,
    String? carefulthing,
    int? expectCalorie,
    int? during,
    int? level,
    List<String>? tags,
    int? interactiveEquipment,
    String? createTime,
    String? courseBgm,
    int? version,
    bool? timing,
    bool? collect,
  }) = _CourseItem;

  factory CourseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseItemFromJson(json);
}
