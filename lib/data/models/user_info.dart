import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

/// 用户个人信息(迁移自旧项目 login_Info.dart 的 FitUserInfo)。
@freezed
abstract class FitUserInfo with _$FitUserInfo {
  const factory FitUserInfo({
    int? id,
    String? nickName,
    bool? sex, // true = 男
    String? birthday,
    int? height,
    int? weight,
    String? headImage,
    String? mailAddress,
    String? phoneNumber,
    String? phoneArea,
    String? createTime,
    bool? disabled,
    bool? hasPsw,
  }) = _FitUserInfo;

  factory FitUserInfo.fromJson(Map<String, dynamic> json) =>
      _$FitUserInfoFromJson(json);
}
