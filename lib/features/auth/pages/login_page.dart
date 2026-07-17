import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';
import 'auth_video_background.dart';

/// 登录入口选择页(1:1 复刻旧项目 NewLoginScreen)。
///
/// 保留原结构:视频背景 + "MADE FITNESS FUN" + 底部三入口(Email/Phone/Account)
/// + 隐私协议勾选。Phone Login 仅在简体中文(languageNum==0)显示,与旧逻辑一致。
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  // 旧项目 privacyPolicyUrl 随语言切换。
  String _privacyUrl(int languageNum) {
    if (languageNum == 2) {
      return 'http://cloud.capstong.com:8081/otaDir/fitmonster_privacy_policy_tw.html';
    } else if (languageNum == 0) {
      return 'http://cloud.capstong.com:8081/otaDir/fitmonster/privacy.html';
    }
    return 'http://cloud.capstong.com:8081/otaDir/fitmonster_privacy_policy_english.html';
  }

  Future<void> _launchPrivacy(int languageNum) async {
    await launchUrl(Uri.parse(_privacyUrl(languageNum)));
  }

  void _ensureAgreed(BuildContext context, WidgetRef ref, VoidCallback go) {
    final agreed = ref.read(authNotifierProvider).agreedToPrivacy;
    if (agreed) {
      go();
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.pleaseAgreePrivacy,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final languageNum =
        ref.watch(authNotifierProvider.select((s) => s.languageNum));
    final agreed =
        ref.watch(authNotifierProvider.select((s) => s.agreedToPrivacy));
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            const AuthVideoBackground(),
            SizedBox(
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 150, margin: const EdgeInsets.only(top: 300).r),
                  SizedBox(height: 15.h),
                  Text(
                    l10n.madeFitnessFun,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.sp,
                      fontFamily: AppFonts.hofontblod,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(left: 25, right: 25, bottom: 50).r,
                    height: 600.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 25.r),
                        // 三入口行
                        Container(
                          width: width,
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (languageNum == 0 || languageNum == 2)
                                SizedBox(width: 30.r),
                              // Email Login
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () => _ensureAgreed(
                                  context,
                                  ref,
                                  () => context.push('/email-login'),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: width / 3,
                                  height: 40.r,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.email_outlined,
                                          color: Colors.white, size: 30.r),
                                      SizedBox(width: 10.r),
                                      Text(
                                        l10n.emailLogin,
                                        style: TextStyle(
                                          fontSize: 25.r,
                                          letterSpacing: 0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Phone Login(仅简中)
                              languageNum == 0
                                  ? Expanded(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () => _ensureAgreed(
                                          context,
                                          ref,
                                          () => context.push('/phone-login'),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 40.r,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/newUIScreen/icons/phone_icon.png',
                                                height: 30.r,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10.r),
                                              Expanded(
                                                child: Text(
                                                  l10n.phoneLogin,
                                                  style: TextStyle(
                                                    fontSize: 25.sp,
                                                    letterSpacing: 0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Expanded(child: Container()),
                              // Account Login
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () => _ensureAgreed(
                                  context,
                                  ref,
                                  () => context.push('/account-login'),
                                ),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: width * 0.28,
                                  height: 40.r,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/newUIScreen/icons/icon_account.png',
                                        height: 35.r,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10.r),
                                      Expanded(
                                        child: Text(
                                          l10n.accountLogin,
                                          style: TextStyle(
                                            fontSize: 25.sp,
                                            letterSpacing: 0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.r),
                        _buildPrivacy(context, ref, l10n, languageNum, agreed),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacy(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    int languageNum,
    bool agreed,
  ) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => ref.read(authNotifierProvider.notifier).togglePrivacyAgreement(),
      child: SizedBox(
        width: 680.w,
        height: 130.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 旧 _buildIconSelect:简中/繁中显示行内隐私链接;其它语言显示居中无链接版。
            (languageNum == 0 || languageNum == 2)
                ? Container(
                    margin: const EdgeInsets.only(left: 25).r,
                    width: width,
                    height: 80.r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          agreed ? Icons.check_circle : Icons.circle_outlined,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        const SizedBox(width: 5),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            l10n.iHaveReadAndAgreeFitMonster,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () => _launchPrivacy(languageNum),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              l10n.userAgreementAndPrivacyPolicy,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.blue,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: width,
                    height: 95.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          agreed ? Icons.check_circle : Icons.circle_outlined,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              l10n.iHaveReadAndAgreeFitMonster,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            // 旧 _buildprivacyWidget 第二段:条件恒为 true(原逻辑 !=0 || !=2),
            // 故始终显示空 Container,保持与旧版完全一致。
            Container(),
          ],
        ),
      ),
    );
  }
}
