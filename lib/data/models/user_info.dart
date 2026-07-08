import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

/// 用户个人信息(迁移自旧项目 login_Info.dart 的 UserInfo)。
@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
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
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
