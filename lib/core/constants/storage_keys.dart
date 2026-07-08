/// 本地存储键名常量(迁移自旧项目 jsp_name.dart)。
///
/// 仅包含登录最小闭环所需键名;其余键名在对应模块迁移时补充。
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'AccessToken';
  static const String userId = 'userId';
  static const String userInfo = 'userInfo'; // UserInfo 的 JSON 字符串
  static const String hasPassword = 'hasPassword';
  static const String headImageHash = 'HeadImageHash';
  static const String languageNum = 'languageNum'; // 0=简中 1=英 2=繁中...
  static const String firstOpenApp = 'FirstOpenApp'; // 首次打开/未登录标志
  static const String country = 'country';
  static const String countryCode = 'countryCode';
  static const String localInChinese = 'localInChinese';
  static const String isSimpleChinese = 'isSimpleChinese';
}
