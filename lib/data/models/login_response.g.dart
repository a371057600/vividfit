// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      code: json['code'] as String?,
      msg: json['msg'] as String?,
      data: json['data'] == null
          ? null
          : LoginData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };

_LoginData _$LoginDataFromJson(Map<String, dynamic> json) => _LoginData(
  userInfo: json['userInfo'] == null
      ? null
      : FitUserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
  token: json['token'] as String?,
);

Map<String, dynamic> _$LoginDataToJson(_LoginData instance) =>
    <String, dynamic>{'userInfo': instance.userInfo, 'token': instance.token};
