import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../states/account_security_state.dart';

part 'account_security_notifier.g.dart';

@Riverpod(keepAlive: false)
class AccountSecurityNotifier extends _$AccountSecurityNotifier {
  @override
  AccountSecurityState build() {
    return const AccountSecurityState();
  }

  void setPhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void setEmailAddress(String value) {
    state = state.copyWith(emailAddress: value);
  }

  void setUnionId(String value) {
    state = state.copyWith(unionId: value);
  }

  void setHasPhoneNumber(bool value) {
    state = state.copyWith(hasPhoneNumber: value);
  }

  void setHasEmailAddress(bool value) {
    state = state.copyWith(hasEmailAddress: value);
  }

  void setVerCode(String value) {
    state = state.copyWith(verCode: value);
  }

  void setAccountAddType(int value) {
    state = state.copyWith(accountAddType: value);
  }

  void setBindAccount(String value) {
    state = state.copyWith(bindAccount: value);
  }

  void setAreaCode(String value) {
    state = state.copyWith(areaCode: value);
  }

  void setCounting(bool isCounting, int counter) {
    state = state.copyWith(isCounting: isCounting, counter: counter);
  }

  void resetCounting() {
    state = state.copyWith(isCounting: false, counter: 0);
  }

  void setInternetStatus(bool hasInternet) {
    state = state.copyWith(ishasInternet: hasInternet);
  }
}