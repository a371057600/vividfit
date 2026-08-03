import 'package:freezed_annotation/freezed_annotation.dart';

part 'third_party_user.freezed.dart';
part 'third_party_user.g.dart';

@freezed
abstract class ThirdPartyUser with _$ThirdPartyUser {
  const factory ThirdPartyUser({
    int? id,
    int? userId,
    String? nickName,
    String? headImgUrl,
    int? type,
    String? openId,
    String? unionId,
    String? province,
    String? city,
    String? country,
    bool? sex,
  }) = _ThirdPartyUser;

  factory ThirdPartyUser.fromJson(Map<String, dynamic> json) =>
      _$ThirdPartyUserFromJson(json);
}
