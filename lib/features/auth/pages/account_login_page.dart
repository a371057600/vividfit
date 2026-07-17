import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';
import 'auth_video_background.dart';

/// 账号密码登录页(1:1 复刻旧项目 NewAccountLoginScreen)。
///
/// 保留原结构:视频背景 + 邮箱/密码输入(UnderlineInputBorder)+ Login 按钮
/// + Register/Forget password 链接 + 左上返回标题。密码显隐图标与旧版一致。
class AccountLoginPage extends ConsumerWidget {
  const AccountLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final showPassword =
        ref.watch(authNotifierProvider.select((s) => s.showPassword));
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
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
                  style: TextStyle(color: Colors.white, fontSize: 25.sp),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: l10n.enterEmail,
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                  onChanged: (value) =>
                      ref.read(authNotifierProvider.notifier).setEmailAccount(value),
                ),
                TextField(
                  obscureText: showPassword,
                  style: TextStyle(color: Colors.white, fontSize: 25.sp),
                  decoration: InputDecoration(
                    suffix: InkWell(
                      onTap: () => ref
                          .read(authNotifierProvider.notifier)
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
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: l10n.enterPassword,
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                  onChanged: (value) =>
                      ref.read(authNotifierProvider.notifier).setPassword(value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(authNotifierProvider.notifier).login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: width - 200.w,
                    child: Text(
                      l10n.login,
                      style: TextStyle(color: Colors.white, fontSize: 30.sp),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(25).r,
                  height: 100.r,
                  width: width,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => context.push('/email-login'),
                        child: Text(
                          l10n.register,
                          style:
                              TextStyle(color: Colors.blue, fontSize: 30.sp),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => context.push('/find-password'),
                        child: Text(
                          l10n.forgetPassword,
                          style:
                              TextStyle(color: Colors.blue, fontSize: 30.sp),
                        ),
                      ),
                    ],
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
                    l10n.accountLogin,
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
