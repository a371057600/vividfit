/// API 端点与请求头常量(迁移自旧项目 address.dart)。
///
/// 当前默认走 CN 服务器;AWS 海外服务器切换在后续 i18n 模块加入。
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://www.ucfitness.club';

  /// 密码登录
  static const String pwdLoginUrl = '$baseUrl/api/public/login/pwd';

  /// 邮箱验证码登录
  static const String mailLoginUrl = '$baseUrl/api/public/login/verCode/mail';

  /// 手机验证码登录
  static const String phoneLoginUrl = '$baseUrl/api/public/login/verCode/phone';

  /// 向邮箱发送验证码
  static const String sendMailNumberUrl = '$baseUrl/api/public/verCode/mail';

  /// 向手机发送验证码
  static const String sendPhoneNumberUrl = '$baseUrl/api/public/verCode/phone';

  /// 验证码校验
  static const String checkNumberUrl = '$baseUrl/api/public/verCode/check';

  /// 是否绑定邮箱
  static const String checkBindMailUrl = '$baseUrl/api/public/isExist/mail';

  /// 是否绑定手机号
  static const String checkBindPhoneUrl = '$baseUrl/api/public/isExist/phone';

  /// 修改密码
  static const String updatePwdUrl = '$baseUrl/api/public/password';

  /// 微信登录(第三方登录)
  static const String wechatLogin = '$baseUrl/api/public/login/thirdPart/weixin';

  /// 下载图片(后续模块用)
  static const String downLoadPictureUrl = '$baseUrl/api/picture/path/';

  /// 获取用户信息(后续 profile 模块用,此处先声明)
  static const String getFitUserInfoUrl = '$baseUrl/api/user/info';

  /// 退出登录
  static const String signOutUrl = '$baseUrl/api/user/signOut';

  /// 注销账号
  static const String deleteFitUserInfoUrl = '$baseUrl/api/user/loginOut';

  /// 刷新 token(后续模块用,此处先声明)
  static const String refreshTokenUrl = '$baseUrl/api/public/refreshToken';

  /// 获取运动统计(主页三环数据)
  static const String getStatisticsUrl = '$baseUrl/api/sport/statistics';

  /// 获取打卡日历(签到检测)
  static const String getStatisticsCalendarUrl =
      '$baseUrl/api/sport/statistics/calendar';

  /// 获取历史运动数据
  static const String historySportDataUrl = '$baseUrl/api/sport/data/history';

  /// 推荐列表(首页 banner)
  static const String recommendListUrl = '$baseUrl/api/course/recommend/list';

  /// 获取徽章总数
  static const String getMedalTotalCountUrl =
      '$baseUrl/api/sport/statistics/user/medal/totalCount';

  /// 版本检测
  static const String versionUpdate = '$baseUrl/api/public/version';

  /// 请求头 key
  static const String headerAppPass = 'app_pass';
  static const String headerAccessToken = 'access_token';

  /// app_pass 固定值(来自旧项目 RequestUrl.appPass)
  static const String appPass = 'Chuan1212';

  /// app_pass2 固定值(来自旧项目 RequestUrl.appPass2)
  static const String appPass2 = 'Chuan-collector';
}
