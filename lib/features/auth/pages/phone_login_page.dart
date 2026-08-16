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

/// 手机登录(发送验证码→跳 GetCodePage)。对应旧项目 NewPhoneLoginScreen。
///
/// 仅简体中文(languageNum==0)入口可见。
class PhoneLoginPage extends ConsumerStatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  ConsumerState<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends ConsumerState<PhoneLoginPage> {
  late TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(authProvider);
    _phoneCtrl = TextEditingController(
      text: s.phoneNumber == 0 ? '' : s.phoneNumber.toString(),
    );
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final n = ref.read(authProvider.notifier);
    final phoneStr = _phoneCtrl.text.trim();
    final parsedPhone = int.tryParse(phoneStr);
    if (phoneStr.isEmpty || parsedPhone == null || parsedPhone <= 0) {
      Fluttertoast.showToast(msg: l10n.enterCorrectPhoneNumber);
      return;
    }
    n
      ..setCountryCode('86')
      ..setPhoneNumber(parsedPhone);
    // 隐私协议前置校验
    if (!ref.read(authProvider).agreedToPrivacy) {
      Fluttertoast.showToast(msg: l10n.pleaseAgreePrivacy);
      return;
    }
    showLoadingDialog(context, message: l10n.getCaptcha);
    try {
      final ok = await n.sendPhoneCaptcha();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (ok) {
        context.push('/get-code');
      }
    } catch (e) {
      print('❌ [PhoneLoginPage] unexpected error: $e');
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
                l10n.phoneLogin,
                style: TextStyle(color: FitTheme.textColor, fontSize: 60.sp),
              ),
              SizedBox(height: 80.r),
              Row(
                children: [
                  Container(
                    width: 100.r,
                    padding: EdgeInsets.symmetric(vertical: 20.r),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: FitTheme.textColor.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+86',
                        style: TextStyle(color: FitTheme.textColor, fontSize: 30.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.r),
                  Expanded(
                    child: TextField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      onChanged: (v) {
                        final p = int.tryParse(v.trim());
                        if (p != null) {
                          ref.read(authProvider.notifier).setPhoneNumber(p);
                        }
                      },
                      style: TextStyle(color: FitTheme.textColor, fontSize: 30.sp),
                      cursorColor: FitTheme.buttonColor,
                      decoration: InputDecoration(
                        labelText: l10n.phoneLogin,
                        labelStyle: TextStyle(color: FitTheme.textColor, fontSize: 28.sp),
                        hintText: l10n.enterPhoneNumber,
                        hintStyle: TextStyle(color: FitTheme.textColor.withValues(alpha: 0.4)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FitTheme.textColor.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: FitTheme.buttonColor),
                        ),
                      ),
                    ),
                  ),
                ],
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
