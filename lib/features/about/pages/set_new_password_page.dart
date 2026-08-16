import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/account_security_notifier.dart';

class SetNewPasswordPage extends ConsumerStatefulWidget {
  const SetNewPasswordPage({super.key});

  @override
  ConsumerState<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends ConsumerState<SetNewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: FitTheme.backgroundColor,
          elevation: 0,
          leadingWidth: 300,
          leading: Container(
            margin: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => context.pop(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_back_ios,
                    color: FitTheme.textColor,
                    size: 20,
                  ),
                  Text(
                    l10n.changePassword,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: FitTheme.backgroundColor,
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _passwordController,
                // 输入同步到 Notifier（对应老代码 onChanged 写 changepassword）
                onChanged: (value) => ref
                    .read(accountSecurityProvider.notifier)
                    .setChangepassword(value),
                obscureText: _obscurePassword,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                ],
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 15),
                  isDense: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitTheme.textColor),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: l10n.password,
                  hintStyle: const TextStyle(color: Colors.grey, height: 1),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                // 输入同步到 Notifier（对应老代码 onChanged 写 changepassword2）
                onChanged: (value) => ref
                    .read(accountSecurityProvider.notifier)
                    .setChangepassword2(value),
                obscureText: _obscureConfirmPassword,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                ],
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    child: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 15),
                  isDense: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitTheme.textColor),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: l10n.confirmPassword,
                  hintStyle: const TextStyle(color: Colors.grey, height: 1),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      FitTheme.buttonColor,
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(340, 50)),
                  ),
                  child: Text(
                    l10n.confirm,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    // 先缓存 notifier 与路由器，await 后不再使用 ref/context（async 安全）
                    final notifier = ref.read(accountSecurityProvider.notifier);
                    final router = GoRouter.of(context);
                    // 两次密码不一致：居中 toast，不提交（老代码行为）
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      Fluttertoast.showToast(
                        msg: l10n.passwordMismatch,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: FitTheme.backgroundColor,
                        textColor: FitTheme.textColor,
                      );
                      return;
                    }
                    // 提交修改密码：PUT /api/public/password
                    final ok = await notifier.updatePassword();
                    if (!mounted) return;
                    if (ok) {
                      // 成功：底部 toast + 返回（对应老代码 Get.back + "success".tr）
                      Fluttertoast.showToast(msg: l10n.success);
                      router.pop();
                    } else {
                      // 失败：老代码 toast "It seems that there is no internet"
                      Fluttertoast.showToast(msg: l10n.itSeemsNoInternet);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
