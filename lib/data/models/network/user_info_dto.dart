import 'package:freezed_annotation/freezed_annotation.dart';

import 'third_party_user.dart';
import '../user_info.dart';

part 'user_info_dto.freezed.dart';
part 'user_info_dto.g.dart';

@freezed
abstract class UserInfoDto with _$UserInfoDto {
  const factory UserInfoDto({
    int? id,
    String? nickName,
    String? birthday,
    bool? sex,
    int? height,
    int? weight,
  }) = _UserInfoDto;

  factory UserInfoDto.fromJson(Map<String, dynamic> json) =>
      _$UserInfoDtoFromJson(json);
}

@freezed
abstract class UserInfoResultDto with _$UserInfoResultDto {
  const factory UserInfoResultDto({
    FitUserInfo? userInfo,
    List<ThirdPartyUser>? thirdPartInfos,
  }) = _UserInfoResultDto;

  factory UserInfoResultDto.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResultDtoFromJson(json);
}
