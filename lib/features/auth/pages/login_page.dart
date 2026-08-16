import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/services/privacy_service_provider.dart';
import '../../../core/utils/policy_urls.dart';
import '../../../core/utils/privacy_policy_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';
import 'auth_video_background.dart';

/// 登录入口选择页(1:1 复刻旧项目 NewLoginScreen)。
///
/// 保留原结构:视频背景 + "MADE FITNESS FUN" + 底部三入口(Email/Phone/Account)
/// + 隐私协议勾选。Phone Login 仅在简体中文(languageNum==0)显示,与旧逻辑一致。
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void _openPrivacy(BuildContext context, int languageNum) {
    final url = PolicyUrls.privacyPolicyUrl(languageNum);
    final title = PolicyUrls.privacyPolicyTitle(languageNum);
    context.push('/policy-webview', extra: {'url': url, 'title': title});
  }

  void _openUserAgreement(BuildContext context, int languageNum) {
    final url = PolicyUrls.userAgreementUrl(languageNum);
    final title = PolicyUrls.userAgreementTitle(languageNum);
    context.push('/policy-webview', extra: {'url': url, 'title': title});
  }

  void _ensureAgreed(BuildContext context, WidgetRef ref, VoidCallback go) {
    final agreed = ref.read(authProvider).agreedToPrivacy;
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
    final languageNum = ref.watch(authProvider.select((s) => s.languageNum));
    final agreed = ref.watch(authProvider.select((s) => s.agreedToPrivacy));
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: 60).r,
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
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(top: 300).r,
                  ),
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
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                      bottom: 50,
                    ).r,
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
                                      Icon(
                                        Icons.email_outlined,
                                        color: Colors.white,
                                        size: 30.r,
                                      ),
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
                        SizedBox(height: 10.r),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16.r,
                          runSpacing: 8.r,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                await ref.read(authProvider.notifier).logout();
                                if (context.mounted) {
                                  Fluttertoast.showToast(msg: '已退出登录');
                                }
                              },
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.redAccent,
                              ),
                              label: const Text(
                                '[调试]清除登录状态',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                await ref
                                    .read(authProvider.notifier)
                                    .devLogin();
                                if (context.mounted) context.go('/home-shell');
                              },
                              icon: const Icon(
                                Icons.developer_board,
                                color: Colors.orange,
                              ),
                              label: Text(
                                l10n.devOneClickLogin,
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                // 模拟新用户注册(code=201 场景)→走一轮:昵称→目标→身体数据→首页
                                // await ref
                                //     .read(authProvider.notifier)
                                //     .devSimulateRegister();
                                // 直接跳转注册流程第一步
                                if (context.mounted) {
                                  context.go('/nickname-setup');
                                }
                              },
                              icon: const Icon(
                                Icons.person_add_alt_1,
                                color: Colors.lightGreenAccent,
                              ),
                              label: const Text(
                                '[调试]走注册流程(新用户)',
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // 调试入口:弹出隐私协议弹窗
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => PrivacyPolicyDialog(
                                    languageNum: languageNum,
                                    onAgree: () async {
                                      final privacy = ref.read(
                                        privacyServiceProvider,
                                      );
                                      await privacy.agreePrivacyPolicy();
                                      ref
                                          .read(authProvider.notifier)
                                          .markPrivacyAgreed();
                                    },
                                    onReject: () async {
                                      final privacy = ref.read(
                                        privacyServiceProvider,
                                      );
                                      await privacy.rejectPrivacyPolicy();
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.privacy_tip,
                                color: Colors.cyanAccent,
                              ),
                              label: const Text(
                                '[调试]查看隐私协议弹窗',
                                style: TextStyle(color: Colors.cyanAccent),
                              ),
                            ),
                            // ElevatedButton(
                            //   onPressed: () => context.go('/api-test'),
                            //   child: const Text('API 测试页'),
                            // ),
                          ],
                        ),
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
      onTap: () => ref.read(authProvider.notifier).togglePrivacyAgreement(),
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
                          onTap: () => _openUserAgreement(context, languageNum),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              l10n.userAgreement,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.blue,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          ' 和 ',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () => _openPrivacy(context, languageNum),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              l10n.privacyPolicy,
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
