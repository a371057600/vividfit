import 'dart:io' show Platform;

import 'storage_service.dart';

/// 隐私政策弹窗显示判断 + 同意/拒绝持久化。
///
/// 三重判断:
///  1. 平台: 仅 Android 触发(iOS 不弹,走系统合规流程)
///  2. 语言: 简体中文(0) 或 繁体中文(2) 才弹
///  3. 存储: 用户从未点过"同意"
class PrivacyService {
  PrivacyService(this._storage);

  final StorageService _storage;

  /// 判断当前是否需要在闪屏后弹出「隐私+用户协议」确认弹窗。
  bool shouldShowPrivacyDialog() {
    final lang = _storage.languageNum;
    final isAndroid = Platform.isAndroid;
    final isZh = lang == 0 || lang == 2;
    final agreed = _storage.privacyPolicyAgreed;
    final show = isAndroid && isZh && !agreed;
    print(
      '🔒 [Privacy] shouldShow=$show '
      '(lang=$lang android=$isAndroid zh=$isZh agreed=$agreed)',
    );
    return show;
  }

  /// 用户点击「同意并继续」:写入 SharedPreferences, 后续不再弹。
  Future<void> agreePrivacyPolicy() async {
    await _storage.setPrivacyPolicyAgreed(true);
    print('🔒 [Privacy] agree → write agreed=true');
  }

  /// 用户点击「拒绝」: 退出 App, 不写入任何标记,下次启动仍然会弹。
  Future<void> rejectPrivacyPolicy() async {
    print('🔒 [Privacy] reject → SystemNavigator.pop');
  }
}
