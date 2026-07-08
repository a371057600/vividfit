import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

/// SharedPreferences 封装。
///
/// 在 `main()` 中通过 `StorageService.create()` 异步初始化,
/// 然后用 ProviderScope override 注入,避免异步 Provider 链。
class StorageService {
  StorageService._(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(prefs);
  }

  // ---- accessToken ----
  String? get accessToken => _prefs.getString(StorageKeys.accessToken);
  Future<void> setAccessToken(String token) =>
      _prefs.setString(StorageKeys.accessToken, token);

  // ---- userId ----
  int? get userId => _prefs.getInt(StorageKeys.userId);
  Future<void> setUserId(int id) => _prefs.setInt(StorageKeys.userId, id);

  // ---- userInfo(JSON 字符串)----
  String? get userInfoJson => _prefs.getString(StorageKeys.userInfo);
  Future<void> setFitUserInfoJson(String json) =>
      _prefs.setString(StorageKeys.userInfo, json);

  // ---- hasPassword ----
  bool? get hasPassword => _prefs.getBool(StorageKeys.hasPassword);
  Future<void> setHasPassword(bool value) =>
      _prefs.setBool(StorageKeys.hasPassword, value);

  // ---- headImageHash ----
  String? get headImageHash => _prefs.getString(StorageKeys.headImageHash);
  Future<void> setHeadImageHash(String value) =>
      _prefs.setString(StorageKeys.headImageHash, value);

  // ---- languageNum(0=简中 1=英 2=繁中,决定 CN 服务器与登录入口显示)----
  int get languageNum => _prefs.getInt(StorageKeys.languageNum) ?? 1;
  Future<void> setLanguageNum(int value) =>
      _prefs.setInt(StorageKeys.languageNum, value);

  // ---- firstOpenApp(旧项目用,控制 splash 后进登录还是首页)----
  bool get firstOpenApp => _prefs.getBool(StorageKeys.firstOpenApp) ?? true;
  Future<void> setFirstOpenApp(bool value) =>
      _prefs.setBool(StorageKeys.firstOpenApp, value);

  // ---- country / countryCode(旧项目 i18n 写入,登录页手机区号用)----
  String? get country => _prefs.getString(StorageKeys.country);
  Future<void> setCountry(String value) =>
      _prefs.setString(StorageKeys.country, value);
  String? get countryCode => _prefs.getString(StorageKeys.countryCode);
  Future<void> setCountryCode(String value) =>
      _prefs.setString(StorageKeys.countryCode, value);

  // ---- 主页模块 ----
  String? get username => _prefs.getString(StorageKeys.username);
  Future<void> setUsername(String v) => _prefs.setString(StorageKeys.username, v);

  int get userHeight => _prefs.getInt(StorageKeys.userHeight) ?? 160;
  Future<void> setUserHeight(int v) => _prefs.setInt(StorageKeys.userHeight, v);

  int get userWeight => _prefs.getInt(StorageKeys.userWeight) ?? 50;
  Future<void> setUserWeight(int v) => _prefs.setInt(StorageKeys.userWeight, v);

  bool get userSex => _prefs.getBool(StorageKeys.userSex) ?? true;
  Future<void> setUserSex(bool v) => _prefs.setBool(StorageKeys.userSex, v);

  String get userBirthday => _prefs.getString(StorageKeys.userBirthday) ?? '1991-01-01';
  Future<void> setUserBirthday(String v) =>
      _prefs.setString(StorageKeys.userBirthday, v);

  int get goalKcal => _prefs.getInt(StorageKeys.goalK) ?? 100;
  Future<void> setGoalKcal(int v) => _prefs.setInt(StorageKeys.goalK, v);

  int get goalDuring => _prefs.getInt(StorageKeys.goalD) ?? 50;
  Future<void> setGoalDuring(int v) => _prefs.setInt(StorageKeys.goalD, v);

  double get goalStrength => _prefs.getDouble(StorageKeys.goalS) ?? 5.0;
  Future<void> setGoalStrength(double v) => _prefs.setDouble(StorageKeys.goalS, v);

  int get selectedCharacterIndex =>
      _prefs.getInt(StorageKeys.selectedCharacterIndex) ?? 0;
  Future<void> setSelectedCharacterIndex(int v) =>
      _prefs.setInt(StorageKeys.selectedCharacterIndex, v);

  bool? get isReached => _prefs.getBool(StorageKeys.isReached);
  Future<void> setIsReached(bool v) => _prefs.setBool(StorageKeys.isReached, v);

  bool? get ishasReport => _prefs.getBool(StorageKeys.ishasReport);
  Future<void> setIshasReport(bool v) => _prefs.setBool(StorageKeys.ishasReport, v);

  bool get hasAiReport => _prefs.containsKey(StorageKeys.aiReport);
  Future<void> removeAiReport() => _prefs.remove(StorageKeys.aiReport);

  String? get myRank => _prefs.getString(StorageKeys.myRank);
  Future<void> setMyRank(String v) => _prefs.setString(StorageKeys.myRank, v);

  String? get tokenDateTime => _prefs.getString(StorageKeys.tokenDateTime);
  Future<void> setTokenDateTime(String v) =>
      _prefs.setString(StorageKeys.tokenDateTime, v);

  int? get firstSettingIndex => _prefs.getInt(StorageKeys.firstSettingIndex);
  Future<void> setFirstSettingIndex(int v) =>
      _prefs.setInt(StorageKeys.firstSettingIndex, v);

  int? get secondSettingIndex => _prefs.getInt(StorageKeys.secondSettingIndex);
  Future<void> setSecondSettingIndex(int v) =>
      _prefs.setInt(StorageKeys.secondSettingIndex, v);

  /// 清除所有登录相关数据(登出时调用)
  Future<void> clearAuth() async {
    await _prefs.remove(StorageKeys.accessToken);
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.userInfo);
    await _prefs.remove(StorageKeys.hasPassword);
    await _prefs.remove(StorageKeys.headImageHash);
  }
}
