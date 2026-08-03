/// 本地存储键名常量(迁移自旧项目 jsp_name.dart)。
///
/// 仅包含登录最小闭环所需键名;其余键名在对应模块迁移时补充。
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'AccessToken';
  static const String userId = 'userId';
  static const String userInfo = 'userInfo'; // FitUserInfo 的 JSON 字符串
  static const String hasPassword = 'hasPassword';
  static const String headImageHash = 'HeadImageHash';
  static const String languageNum = 'languageNum'; // 0=简中 1=英 2=繁中...
  static const String firstOpenApp = 'FirstOpenApp'; // 首次打开/未登录标志
  static const String country = 'country';
  static const String countryCode = 'countryCode';
  static const String localInChinese = 'localInChinese';
  static const String isSimpleChinese = 'isSimpleChinese';
  static const String username = 'userName';
  static const String userBirthday = 'UserBirthday';
  static const String userSex = 'userSex'; // true=男
  static const String userWeight = 'userWeight';
  static const String userHeight = 'userHeight';
  static const String phoneNumber = 'phoneNumber';
  static const String emailAddress = 'emailAddress';
  static const String goalK = 'GoalKcal';
  static const String goalD = 'GoalDuring';
  static const String goalS = 'GoalStrength';
  static const String goalBmi = 'goalBmi';
  static const String firstSettingIndex = 'firstSettingIndex';
  static const String secondSettingIndex = 'secondSettingIndex';
  static const String isReached = 'isReached'; // 今日是否打卡
  static const String ishasReport = 'ishasReport'; // 是否有 AI 报告
  static const String aiReport = 'aiReport';
  static const String myRank = 'myRank';
  static const String tokenDateTime = 'TokenDateTime';
  static const String selectedCharacterIndex = 'selectedCharacterIndex';
  static const String tricycliDuring = 'tricycliDuring';
  static const String tricycliSportStrength = 'tricycliSportStrength';
  static const String tricyclicalorie = 'tricyclicalorie';
  /// 蓝牙权限告知弹窗是否已展示过（仅 Android 首次弹窗机制）
  static const String btPermissionDialogShown = 'BtPermissionDialogShown';

  // ---- 大设备模块 ----
  static const String bikeMachine = 'bikeMachine';
  static const String treadmill = 'treadmill';
  static const String ellipticalMachine = 'ellipticalMachine';
  static const String powerMachine = 'powerMachine';
  static const String powerStationMachine = 'powerStationMachine';
}
