import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../core/services/storage_service_provider.dart';
import '../../../l10n/app_localizations.dart';

/// 注册流程第1步:设置昵称(对应旧项目 NewUserDataNickNameSettingsScreen)。
///
/// 校验规则:5~10 字符,通过后跳注册流程第2步(body-data)。
class NicknameSetupPage extends ConsumerStatefulWidget {
  const NicknameSetupPage({super.key});

  @override
  ConsumerState<NicknameSetupPage> createState() => _NicknameSetupPageState();
}

class _NicknameSetupPageState extends ConsumerState<NicknameSetupPage> {
  final _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
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
        centerTitle: false,
        leadingWidth: 50.w,
        iconTheme: IconThemeData(color: FitTheme.textColor),
        title: Text(
          l10n.nickname,
          style: TextStyle(color: FitTheme.textColor, fontSize: 40.sp),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 50,
          left: 30,
          right: 30,
          bottom: 40,
        ).r,
        child: Column(
          children: [
            SizedBox(height: 50.r),
            Text(
              l10n.nickname,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 40.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.r),
            TextField(
              controller: _nicknameController,
              style: TextStyle(color: FitTheme.textColor),
              cursorColor: FitTheme.buttonColor,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: FitTheme.buttonColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: FitTheme.buttonColor),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: FitTheme.buttonColor),
                ),
                // TODO(l10n): 待补充 enterNickname 文案
                hintText: '请输入昵称',
                hintStyle: TextStyle(color: FitTheme.textColor),
              ),
            ),
            const Spacer(),
            Container(
              width: width,
              margin: const EdgeInsets.all(40).r,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: const Color.fromARGB(
                    80,
                    255,
                    55,
                    35,
                  ),
                  backgroundColor: FitTheme.buttonColor,
                ),
                onPressed: () async {
                  final name = _nicknameController.text.trim();
                  if (name.length > 5 && name.length < 10) {
                    // 保存昵称到本地 → 跳身体数据页
                    final storage = ref.read(storageServiceProvider);
                    await storage.setUsername(name);
                    print(
                      '🔐 [NicknameSetup] nickname=$name, go next -> /body-data',
                    );
                    if (!context.mounted) return;
                    context.push('/body-data', extra: {'isRegistration': true});
                  } else {
                    // TODO(l10n): 待补充 nicknameLengthHint 文案
                    Fluttertoast.showToast(msg: '请输入 5-10 个字符的昵称');
                  }
                },
                child: Text(
                  // TODO(l10n): 待补充 next 文案
                  '下一步',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
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
}
