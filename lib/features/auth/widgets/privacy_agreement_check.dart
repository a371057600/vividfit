import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/utils/policy_urls.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';

/// 隐私协议勾选组件(可复用)。
///
/// 用于登录子页面(手机/邮箱/账号登录页)底部,与登录主页保持一致交互:
///  - 点击切换勾选状态(复用 AuthState.agreedToPrivacy)
///  - "用户协议"/"隐私政策"可点击跳转在线 WebView
///  - 简中/繁中显示行内协议链接,其他语言仅显示文案
class PrivacyAgreementCheck extends ConsumerWidget {
  const PrivacyAgreementCheck({super.key});

  void _openPolicy(BuildContext context, int languageNum, bool isPrivacy) {
    final url = isPrivacy
        ? PolicyUrls.privacyPolicyUrl(languageNum)
        : PolicyUrls.userAgreementUrl(languageNum);
    final title = isPrivacy
        ? PolicyUrls.privacyPolicyTitle(languageNum)
        : PolicyUrls.userAgreementTitle(languageNum);
    context.push('/policy-webview', extra: {'url': url, 'title': title});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final languageNum = ref.watch(authProvider.select((s) => s.languageNum));
    final agreed = ref.watch(authProvider.select((s) => s.agreedToPrivacy));
    final width = MediaQuery.of(context).size.width;
    final isCn = languageNum == 0 || languageNum == 2;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => ref.read(authProvider.notifier).togglePrivacyAgreement(),
      child: SizedBox(
        width: width,
        child: isCn
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    agreed ? Icons.check_circle : Icons.circle_outlined,
                    color: FitTheme.textColor,
                    size: 30.sp,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    l10n.iHaveReadAndAgreeFitMonster,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: FitTheme.textColor,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => _openPolicy(context, languageNum, false),
                    child: Text(
                      l10n.userAgreement,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    ' 和 ',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: FitTheme.textColor,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => _openPolicy(context, languageNum, true),
                    child: Text(
                      l10n.privacyPolicy,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    agreed ? Icons.check_circle : Icons.circle_outlined,
                    color: FitTheme.textColor,
                    size: 30.sp,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      l10n.iHaveReadAndAgreeFitMonster,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: FitTheme.textColor,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
