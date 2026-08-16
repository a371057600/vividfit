import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/account_security_notifier.dart';
import '../states/account_security_state.dart';

/// 绑定验证方式页（对应旧 NewAddVerificationModeScreen）。
///
/// [accountAddType] 0=绑定手机 1=绑定邮箱（设置密码流程未绑定时传 1，先绑邮箱）。
class AddVerificationMethodPage extends ConsumerStatefulWidget {
  const AddVerificationMethodPage({super.key, this.accountAddType = 0});

  final int accountAddType;

  @override
  ConsumerState<AddVerificationMethodPage> createState() =>
      _AddVerificationMethodPageState();
}

class _AddVerificationMethodPageState
    extends ConsumerState<AddVerificationMethodPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(accountSecurityProvider);
    final isPhone = widget.accountAddType == 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: FitTheme.backgroundColor,
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
                  isPhone ? l10n.bindNewPhone : l10n.bindNewEmail,
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
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          children: [
            _buildInputTypeWidget(isPhone, l10n),
            _buildVerificationCodeField(l10n, state),
            const SizedBox(height: 20),
            const Spacer(),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                // 提交绑定（对应老 bindingAccount case 0/3）
                // await 前捕获 router，避免跨异步间隙使用 BuildContext
                final router = GoRouter.of(context);
                final notifier = ref.read(accountSecurityProvider.notifier);
                final code = await notifier.bindAccount(widget.accountAddType);
                if (!mounted) return;
                if (code == '200') {
                  // 老代码：绑定成功直接返回上一页（账号安全页自动刷新列表）
                  router.pop(true);
                } else if (code == '405') {
                  Fluttertoast.showToast(msg: l10n.accountBound);
                } else if (code == '400') {
                  Fluttertoast.showToast(msg: l10n.incorrectVerificationCode);
                } else {
                  Fluttertoast.showToast(msg: l10n.itSeemsNoInternet);
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4B22),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                height: 40,
                width: 180,
                child: Text(
                  l10n.confirm,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputTypeWidget(bool isPhone, AppLocalizations l10n) {
    if (isPhone) {
      return IntlPhoneField(
        dropdownTextStyle: TextStyle(color: FitTheme.textColor),
        style: TextStyle(color: FitTheme.textColor),
        decoration: InputDecoration(
          hintText: l10n.enterPhoneNumber,
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: FitTheme.textColor),
          counterStyle: TextStyle(color: FitTheme.textColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: FitTheme.textColor),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: FitTheme.textColor, width: 1),
          ),
        ),
        languageCode: "cn",
        invalidNumberMessage: l10n.enterCorrectPhoneNumber,
        initialCountryCode: "CN",
        onChanged: (phone) {
          // 输入同步到 Notifier（对应老 asc.bindAccount / areaCode）
          final notifier = ref.read(accountSecurityProvider.notifier);
          notifier.setBindAccount(phone.number);
          notifier.setAreaCode(phone.countryCode.replaceFirst("+", ""));
        },
        onCountryChanged: (country) {},
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: TextField(
          style: TextStyle(color: FitTheme.textColor, fontSize: 15),
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: FitTheme.textColor),
            ),
            hintText: l10n.enterEmail,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            // 输入同步到 Notifier（对应老 asc.bindAccount）
            ref
                .read(accountSecurityProvider.notifier)
                .setBindAccount(value);
          },
        ),
      );
    }
  }

  Widget _buildVerificationCodeField(
    AppLocalizations l10n,
    AccountSecurityState state,
  ) {
    return Stack(
      children: [
        TextField(
          style: TextStyle(color: FitTheme.textColor, fontSize: 15),
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: FitTheme.textColor),
            ),
            hintText: l10n.verificationCode,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            // 输入同步到 Notifier（对应老 asc.verCode）
            ref.read(accountSecurityProvider.notifier).setVerCode(value);
          },
        ),
        Positioned(
          bottom: 10,
          right: 5,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              // 发送绑定验证码：倒计时中不可重复发送（对应老 sendverCode）
              if (!state.isCounting) {
                final code =
                    ref
                        .read(accountSecurityProvider.notifier)
                        .sendBindVerCode(widget.accountAddType);
                // 405 提示已被绑定（请求失败信息由日志输出）
                code.then((value) {
                  if (value == '405' && mounted) {
                    Fluttertoast.showToast(msg: l10n.accountBound);
                  }
                });
              }
            },
            child: state.isCounting
                ? Text(
                    '${l10n.codeSent}(${state.counter})',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    l10n.getCode,
                    style: TextStyle(
                      color: FitTheme.buttonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
