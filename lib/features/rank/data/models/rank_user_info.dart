import 'package:freezed_annotation/freezed_annotation.dart';

part 'rank_user_info.freezed.dart';
part 'rank_user_info.g.dart';

@freezed
abstract class RankUserInfo with _$RankUserInfo {
  const factory RankUserInfo({
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'msg') String? msg,
    @JsonKey(name: 'data') RankUserData? data,
  }) = _RankUserInfo;

  factory RankUserInfo.fromJson(Map<String, dynamic> json) =>
      _$RankUserInfoFromJson(json);
}

@freezed
abstract class RankUserData with _$RankUserData {
  const factory RankUserData({
    @JsonKey(name: 'myRank') int? myRank,
    @JsonKey(name: 'calories') double? calories,
    @JsonKey(name: 'count') int? count,
  }) = _RankUserData;

  factory RankUserData.fromJson(Map<String, dynamic> json) =>
      _$RankUserDataFromJson(json);
}
