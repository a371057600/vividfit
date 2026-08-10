/// 隐私政策与用户协议的 OSS 在线 URL 多语言映射。
///
/// 对应旧项目 HomeController.privacyPolicyUrl.value 与
/// NewLoginController 根据 languageNum 切换 URL 的逻辑。
/// 中文(简/繁)统一走 vividfit_v2 指定的新 OSS 链接,英文沿用旧服务器。
class PolicyUrls {
  PolicyUrls._();

  // ====== 用户指定的最新协议链接(简体中文) ======
  static const String _cnPrivacy =
      'https://code.vividfit.cn/protocol/vivid_privacy_policy_cn.html';
  static const String _cnUserAgreement =
      'https://code.vividfit.cn/protocol/vivid_user_agreement_cn.html';

  // ====== 旧项目历史链接 ======
  // 繁中
  static const String _twPrivacy =
      'http://cloud.capstong.com:8081/otaDir/fitmonster_privacy_policy_tw.html';
  // 简中(历史备用)
  static const String _cnLegacyPrivacy =
      'http://cloud.capstong.com:8081/otaDir/fitmonster/privacy.html';
  // 英文
  static const String _enPrivacy =
      'http://cloud.capstong.com:8081/otaDir/fitmonster_privacy_policy_english.html';

  /// 根据 languageNum 返回对应语言的 隐私政策 URL。
  ///
  /// languageNum: 0=简中 1=英文 2=繁中, 其它值 fallback 英文。
  static String privacy(int languageNum) {
    switch (languageNum) {
      case 0:
        return _cnPrivacy; // 简体中文 → 新 OSS
      case 2:
        return _twPrivacy; // 繁体中文 → 旧繁中页
      case 1:
      default:
        return _enPrivacy; // 英文 / 其它
    }
  }

  /// 根据 languageNum 返回对应语言的 用户协议 URL。
  ///
  /// 用户协议 OSS 目前只提供简体中文,其它语言先复用简中页。
  static String userAgreement(int languageNum) {
    switch (languageNum) {
      case 0:
      case 2:
      case 1:
      default:
        return _cnUserAgreement;
    }
  }

  /// 仅用于关于页展示给用户看到的"隐私政策"标签标题建议(简中)。
  static const String labelPrivacyCn = '隐私政策';
  static const String labelUserAgreementCn = '用户协议';
  static const String labelPrivacyEn = 'Privacy Policy';
  static const String labelUserAgreementEn = 'User Agreement';

  /// 弹窗内标题: 根据语言返回 Tab 标题 [用户协议, 隐私政策]。
  static List<String> tabTitles(int languageNum) {
    final isCn = languageNum == 0 || languageNum == 2;
    return [
      isCn ? labelUserAgreementCn : labelUserAgreementEn,
      isCn ? labelPrivacyCn : labelPrivacyEn,
    ];
  }

  // 忽略警告: _cnLegacyPrivacy 保留以便未来回退参考
  @Deprecated('历史备用链接,默认使用 _cnPrivacy')
  static String get cnLegacyPrivacy => _cnLegacyPrivacy;

  // ====== 给 Login / About 页面用的便捷封装 ======
  static String privacyPolicyUrl(int languageNum) => privacy(languageNum);
  static String userAgreementUrl(int languageNum) => userAgreement(languageNum);

  static String privacyPolicyTitle(int languageNum) {
    final isCn = languageNum == 0 || languageNum == 2;
    return isCn ? labelPrivacyCn : labelPrivacyEn;
  }

  static String userAgreementTitle(int languageNum) {
    final isCn = languageNum == 0 || languageNum == 2;
    return isCn ? labelUserAgreementCn : labelUserAgreementEn;
  }
}
