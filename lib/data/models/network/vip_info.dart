import 'package:freezed_annotation/freezed_annotation.dart';

part 'vip_info.freezed.dart';
part 'vip_info.g.dart';

@freezed
abstract class VipInfo with _$VipInfo {
  const factory VipInfo({
    int? userId,
    String? upgradeTime,
    String? expireTime,
    bool? withinTheTerm,
  }) = _VipInfo;

  factory VipInfo.fromJson(Map<String, dynamic> json) =>
      _$VipInfoFromJson(json);
}
