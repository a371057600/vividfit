import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/utils/loading_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/auth_notifier.dart';
import '../widgets/privacy_agreement_check.dart';

/// 邮箱登录(发送验证码→跳 GetCodePage)。对应旧项目 NewEmailLoginScreen。
class EmailLoginPage extends ConsumerStatefulWidget {
  const EmailLoginPage({super.key});

  @override
  ConsumerState<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends ConsumerState<EmailLoginPage> {
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(
      text: ref.read(authProvider).emailAccount,
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final n = ref.read(authProvider.notifier);
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: l10n.enterEmail);
      return;
    }
    if (!email.contains('@')) {
      Fluttertoast.showToast(msg: l10n.enterEmail);
      return;
    }
    n.setEmailAccount(email);
    // 隐私协议前置校验
    if (!ref.read(authProvider).agreedToPrivacy) {
      Fluttertoast.showToast(msg: l10n.pleaseAgreePrivacy);
      return;
    }
    showLoadingDialog(context, message: l10n.getCaptcha);
    try {
      final ok = await n.sendEmailCaptcha();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (ok) {
        context.push('/get-code');
      }
    } catch (e) {
      print('❌ [EmailLoginPage] unexpected error: $e');
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: FitTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: FitTheme.backgroundColor,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            if (context.canPop()) context.pop();
          },
          child: Icon(Icons.arrow_back_ios, color: FitTheme.textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 60.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.r),
              Text(
                l10n.emailLogin,
                style: TextStyle(color: FitTheme.textColor, fontSize: 60.sp),
              ),
              SizedBox(height: 80.r),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: ref.read(authProvider.notifier).setEmailAccount,
                style: TextStyle(color: FitTheme.textColor, fontSize: 30.sp),
                cursorColor: FitTheme.buttonColor,
                decoration: InputDecoration(
                  labelText: l10n.emailLogin,
                  labelStyle: TextStyle(color: FitTheme.textColor, fontSize: 28.sp),
                  hintText: l10n.enterEmail,
                  hintStyle: TextStyle(color: FitTheme.textColor.withValues(alpha: 0.4)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitTheme.textColor.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitTheme.buttonColor),
                  ),
                ),
              ),
              SizedBox(height: 120.r),
              SizedBox(
                width: width,
                height: 90.r,
                child: ElevatedButton(
                  onPressed: () => _submit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FitTheme.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    l10n.getCaptcha,
                    style: TextStyle(
                      color: FitTheme.textButtonColor,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.r),
              const PrivacyAgreementCheck(),
            ],
          ),
        ),
      ),
    );
  }
}
