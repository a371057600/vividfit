import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_detail.freezed.dart';
part 'course_detail.g.dart';

@freezed
class CourseDetail with _$CourseDetail {
  const factory CourseDetail({
    String? code,
    String? msg,
    List<CourseAction>? data,
  }) = _CourseDetail;

  factory CourseDetail.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailFromJson(json);
}

@freezed
class CourseAction with _$CourseAction {
  const factory CourseAction({
    int? actionId,
    int? actionType,
    String? video,
    String? cover,
    String? actionName,
    String? actionVoice,
    String? actionIntroduce,
    String? actionIntroduceVoice,
    int? targetAmount,
    int? during,
    int? sets,
    int? speed,
    ActionPictures? picturesList,
  }) = _CourseAction;

  factory CourseAction.fromJson(Map<String, dynamic> json) =>
      _$CourseActionFromJson(json);
}

@freezed
class ActionPictures with _$ActionPictures {
  const factory ActionPictures({
    int? id,
    int? actionId,
    String? actionPictureName,
    String? actionPictureHash,
  }) = _ActionPictures;

  factory ActionPictures.fromJson(Map<String, dynamic> json) =>
      _$ActionPicturesFromJson(json);
}
