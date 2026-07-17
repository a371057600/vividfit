import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';
import 'auth_video_background.dart';

/// 手机验证码登录-输入手机号页(1:1 复刻旧项目 NewPhoneLoginScreen)。
///
/// 保留原结构:视频背景 + IntlPhoneField + Get Captcha 按钮。
class PhoneLoginPage extends ConsumerWidget {
  const PhoneLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const AuthVideoBackground(),
          Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 50, right: 50).r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IntlPhoneField(
                  dropdownTextStyle:
                      TextStyle(color: FitTheme.backgroundColor),
                  style: TextStyle(color: FitTheme.backgroundColor),
                  decoration: InputDecoration(
                    hintText: l10n.enterPhoneNumber,
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle:
                        TextStyle(color: FitTheme.backgroundColor),
                    counterStyle:
                        TextStyle(color: FitTheme.backgroundColor),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: FitTheme.backgroundColor),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FitTheme.backgroundColor,
                        width: 1,
                      ),
                    ),
                  ),
                  languageCode: 'cn',
                  invalidNumberMessage: l10n.enterCorrectPhoneNumber,
                  initialCountryCode: 'CN',
                  onChanged: (phone) {
                    ref
                        .read(authNotifierProvider.notifier)
                        .setCountryCode(phone.countryCode.replaceFirst('+', ''));
                    ref
                        .read(authNotifierProvider.notifier)
                        .setPhoneNumber(int.tryParse(phone.number) ?? 0);
                  },
                  onCountryChanged: (country) {},
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final state = ref.read(authNotifierProvider);
                    if (state.ishasInternet && state.phoneNumber != 0) {
                      final ok = await ref
                          .read(authNotifierProvider.notifier)
                          .sendPhoneCaptcha();
                      if (ok && context.mounted) {
                        context.pushReplacement('/get-code');
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: l10n.noInternetConnectionOrNoInput,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                  ),
                  child: Container(
                    width: width * 0.8,
                    alignment: Alignment.center,
                    child: Text(
                      l10n.getCaptcha,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100.r,
            left: 25.r,
            child: InkWell(
              onTap: () => context.pop(),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 50.sp),
                  SizedBox(width: 10.r),
                  Text(
                    l10n.phoneLogin,
                    style: TextStyle(color: Colors.white, fontSize: 40.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
