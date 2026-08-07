import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

class AddVerificationMethodPage extends ConsumerStatefulWidget {
  const AddVerificationMethodPage({super.key, this.accountAddType = 0});

  final int accountAddType;

  @override
  ConsumerState<AddVerificationMethodPage> createState() =>
      _AddVerificationMethodPageState();
}

class _AddVerificationMethodPageState
    extends ConsumerState<AddVerificationMethodPage> {
  String _bindAccount = '';
  String _areaCode = '';
  String _verCode = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            _buildVerificationCodeField(l10n),
            const SizedBox(height: 20),
            const Spacer(),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                context.pop();
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
          setState(() {
            _bindAccount = phone.number;
            _areaCode = phone.countryCode.replaceFirst("+", "");
          });
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
            setState(() {
              _bindAccount = value;
            });
          },
        ),
      );
    }
  }

  Widget _buildVerificationCodeField(AppLocalizations l10n) {
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
            setState(() {
              _verCode = value;
            });
          },
        ),
        Positioned(
          bottom: 10,
          right: 5,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              // TODO: 后续接入发送验证码业务逻辑 + 倒计时
            },
            child: Text(
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
