import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_security_state.freezed.dart';

@freezed
abstract class AccountSecurityState with _$AccountSecurityState {
  const factory AccountSecurityState({
    @Default('') String phoneNumber,
    @Default('') String emailAddress,
    @Default('') String unionId,
    @Default(false) bool hasPhoneNumber,
    @Default(false) bool hasEmailAddress,
    @Default('') String verCode,
    @Default(false) bool isCounting,
    @Default(0) int counter,
    @Default(0) int accountAddType,
    @Default('') String bindAccount,
    @Default('') String areaCode,
    @Default(false) bool isLoading,
    @Default(true) bool ishasInternet,
  }) = _AccountSecurityState;
}