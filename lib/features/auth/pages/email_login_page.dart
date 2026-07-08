import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_providers.dart';
import 'auth_video_background.dart';

/// 邮箱验证码登录-输入邮箱页(1:1 复刻旧项目 NewEmailLoginScreen)。
///
/// 保留原结构:视频背景 + 邮箱输入 + Get Captcha 按钮(带倒计时)。
/// 发送成功后跳转验证码输入页(GetCodePage)。
class EmailLoginPage extends ConsumerWidget {
  const EmailLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final reGetCode2 =
        ref.watch(authNotifierProvider.select((s) => s.reGetCode2));
    final countdown =
        ref.watch(authNotifierProvider.select((s) => s.countdown));
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
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  style: TextStyle(color: FitTheme.backgroundColor),
                  decoration: InputDecoration(
                    hintText: l10n.enterEmail,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) => ref
                      .read(authNotifierProvider.notifier)
                      .setEmailAccount(value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final state = ref.read(authNotifierProvider);
                    if (state.ishasInternet &&
                        state.emailAccount.isNotEmpty &&
                        state.reGetCode2) {
                      final ok = await ref
                          .read(authNotifierProvider.notifier)
                          .sendEmailCaptcha();
                      if (ok && context.mounted) {
                        // 旧 Get.off(GetCode):替换当前页,返回时回到入口。
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
                    disabledBackgroundColor:
                        FitTheme.buttonColor.withValues(alpha: 0.5),
                  ),
                  child: Container(
                    width: width * 0.8,
                    alignment: Alignment.center,
                    child: Text(
                      reGetCode2 ? l10n.getCaptcha : '${countdown}s',
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
                    l10n.emailLogin,
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
