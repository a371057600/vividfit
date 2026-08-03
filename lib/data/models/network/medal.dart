import 'package:freezed_annotation/freezed_annotation.dart';

part 'medal.freezed.dart';
part 'medal.g.dart';

@freezed
abstract class MedalMsg with _$MedalMsg {
  const factory MedalMsg({
    int? id,
    String? name,
    String? image,
    String? describe,
    String? group,
    int? target,
    bool? have,
    bool? read,
    String? createTime,
  }) = _MedalMsg;

  factory MedalMsg.fromJson(Map<String, dynamic> json) =>
      _$MedalMsgFromJson(json);
}

@freezed
abstract class MedalGroup with _$MedalGroup {
  const factory MedalGroup({
    String? groupName,
    List<MedalMsg>? medals,
  }) = _MedalGroup;

  factory MedalGroup.fromJson(Map<String, dynamic> json) =>
      _$MedalGroupFromJson(json);
}

@freezed
abstract class ReadMedal with _$ReadMedal {
  const factory ReadMedal({
    int? userId,
    List<int>? medalIds,
  }) = _ReadMedal;

  factory ReadMedal.fromJson(Map<String, dynamic> json) =>
      _$ReadMedalFromJson(json);
}
