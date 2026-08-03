import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';
import 'auth_video_background.dart';

/// 找回密码页(1:1 复刻旧项目 NewFindPasswordScreen)。
///
/// 保留原结构:视频背景 + 邮箱/新密码/验证码输入 + Get code 倒计时 + Set Password 按钮。
/// 成功后回到入口选择页(旧 Get.off(NewLoginScreen))。
class FindPasswordPage extends ConsumerWidget {
  const FindPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final showPassword =
        ref.watch(authProvider.select((s) => s.showPassword));
    final reGetCode2 =
        ref.watch(authProvider.select((s) => s.reGetCode2));
    final countdown =
        ref.watch(authProvider.select((s) => s.countdown));
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
                TextField(
                  style: TextStyle(
                    color: FitTheme.backgroundColor,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: FitTheme.backgroundColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: FitTheme.backgroundColor),
                    ),
                    hintText: l10n.enterEmail,
                    hintStyle: TextStyle(color: FitTheme.backgroundColor),
                  ),
                  onChanged: (value) => ref
                      .read(authProvider.notifier)
                      .setEmailAccount(value),
                ),
                TextField(
                  obscureText: showPassword,
                  style: TextStyle(
                    color: FitTheme.backgroundColor,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    suffix: InkWell(
                      onTap: () => ref
                          .read(authProvider.notifier)
                          .toggleShowPassword(),
                      child: SizedBox(
                        height: 50.r,
                        width: 50.r,
                        child: showPassword
                            ? Image.asset(
                                'images/newUIScreen/icons/icon_password_show.png',
                              )
                            : Image.asset(
                                'images/newUIScreen/icons/icon_password_close.png',
                              ),
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: FitTheme.backgroundColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: FitTheme.backgroundColor),
                    ),
                    hintText: l10n.enterPassword,
                    hintStyle: TextStyle(color: FitTheme.backgroundColor),
                  ),
                  onChanged: (value) => ref
                      .read(authProvider.notifier)
                      .setChangePassword(value),
                ),
                Stack(
                  children: [
                    TextField(
                      style: TextStyle(
                        color: FitTheme.backgroundColor,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FitTheme.backgroundColor,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FitTheme.backgroundColor,
                          ),
                        ),
                        hintText: l10n.enterCode,
                        hintStyle: TextStyle(
                          color: FitTheme.backgroundColor,
                        ),
                      ),
                      onChanged: (value) => ref
                          .read(authProvider.notifier)
                          .setCaptcha(value),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 30.r,
                      child: reGetCode2
                          ? InkWell(
                              onTap: () => ref
                                  .read(authProvider.notifier)
                                  .sendEmailCaptcha(),
                              child: Text(
                                l10n.getCode,
                                style: TextStyle(
                                  color: FitTheme.buttonColor,
                                  fontSize: 30.sp,
                                ),
                              ),
                            )
                          : Text(countdown.toString()),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final ok = await ref
                        .read(authProvider.notifier)
                        .checkCaptchaAndResetPassword();
                    if (ok && context.mounted) {
                      // 旧 Get.off(NewLoginScreen):回到入口选择页。
                      context.go('/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: width * 0.8,
                    child: Text(
                      l10n.setPassword,
                      style: TextStyle(color: Colors.white, fontSize: 30.sp),
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
                    l10n.forgetPassword,
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
