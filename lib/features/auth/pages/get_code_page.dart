import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_providers.dart';
import 'auth_video_background.dart';

/// 验证码输入页(1:1 复刻旧项目 NewLoginGetCodeScreen)。
///
/// 保留原结构:视频背景 + Pinput(6位)+ Re-get/倒计时按钮 + 左上返回标题。
/// Pinput 输入完成调用 selectLoginType 触发验证码登录,成功后由路由重定向到首页。
class GetCodePage extends ConsumerWidget {
  const GetCodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final reGetCode =
        ref.watch(authNotifierProvider.select((s) => s.reGetCode));
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
            padding: const EdgeInsets.only(left: 20, right: 20),
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    margin: const EdgeInsets.all(5),
                    width: 45,
                    height: 45,
                    textStyle: TextStyle(
                      fontSize: 22,
                      color: FitTheme.backgroundColor,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: FitTheme.backgroundColor),
                    ),
                  ),
                  onCompleted: (String pin) {
                    if (pin.length == 6) {
                      ref
                          .read(authNotifierProvider.notifier)
                          .selectLoginType(pin);
                    }
                  },
                ),
                Container(
                  width: width,
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: const Color.fromARGB(
                        80,
                        236,
                        228,
                        227,
                      ),
                      backgroundColor: FitTheme.buttonColor,
                    ),
                    onPressed: reGetCode
                        ? () {
                            ref
                                .read(authNotifierProvider.notifier)
                                .regetCode();
                          }
                        : null,
                    child: Text(
                      reGetCode ? l10n.reGet : countdown.toString(),
                      style: TextStyle(
                        color: FitTheme.textButtonColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            top: 100.r,
            left: 25.r,
            child: InkWell(
              // 旧 Get.off(NewLoginScreen):返回到入口选择页。
              onTap: () => context.go('/login'),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 50.sp),
                  SizedBox(width: 10.r),
                  Text(
                    l10n.getCodeTitle,
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
