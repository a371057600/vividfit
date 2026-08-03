/// API 端点与请求头常量（基于 Swagger 文档迁移）。
///
/// Host: code.vividfit.cn:443
/// 所有接口均需 app_pass header，固定值 rido1234。
class ApiConstants {
  ApiConstants._();

  /// 服务器基础地址
  static const String baseUrl = 'https://code.vividfit.cn';

  // ============ 请求头 ============

  /// 请求通行证 header key
  static const String headerAppPass = 'app_pass';

  /// 用户 token header key
  static const String headerAccessToken = 'access_token';

  /// app_pass 固定值
  static const String appPass = 'rido1234';

  /// app_pass2 固定值（收集服务器用）
  static const String appPass2 = 'Chuan-collector';

  // ============ public-controller（11 个） ============

  /// 密码登录 → POST，返回 LoginResultDto（直返）
  static const String pwdLogin = '/api/public/login/pwd';

  /// 邮箱验证码登录 → POST，返回 LoginResultDto（直返）
  static const String mailLogin = '/api/public/login/verCode/mail';

  /// 手机验证码登录 → POST，返回 LoginResultDto（直返）
  static const String phoneLogin = '/api/public/login/verCode/phone';

  /// 微信第三方登录 → POST，返回 LoginResultDto（直返）
  static const String weixinLogin = '/api/public/login/thirdPart/weixin';

  /// 检查邮箱是否已绑定 → GET，返回 User（直返）
  static const String checkBindMail = '/api/public/isExist/mail';

  /// 检查手机号是否已绑定 → GET，返回 User（直返）
  static const String checkBindPhone = '/api/public/isExist/phone';

  /// 修改密码 → PUT，返回 ResultDto
  static const String updatePassword = '/api/public/password';

  /// 刷新 token → GET，返回 string（直返）
  static const String refreshToken = '/api/public/refreshToken';

  /// 验证码校验 → GET，返回 ResultDto
  static const String checkVerCode = '/api/public/verCode/check';

  /// 向邮箱发送验证码 → GET，返回 ResultDto
  static const String sendMailVerCode = '/api/public/verCode/mail';

  /// 向手机发送验证码 → GET，返回 ResultDto
  static const String sendPhoneVerCode = '/api/public/verCode/phone';

  // ============ user-controller（9 个） ============

  /// 获取/修改用户信息 → GET/PUT，返回 UserInfoResultDto/User（直返）
  static const String userInfo = '/api/user/info';

  /// 修改用户头像 → PUT multipart，返回 string（直返）
  static const String updateHeadImg = '/api/user/headImg';

  /// 退出登录 → GET，返回 ResultDto
  static const String signOut = '/api/user/signOut';

  /// 注销账号 → GET，返回 ResultDto
  static const String deleteAccount = '/api/user/loginOut';

  /// 修改邮箱 → PUT，返回 ResultDto
  static const String updateMail = '/api/user/mail';

  /// 修改手机号 → PUT，返回 ResultDto
  static const String updatePhone = '/api/user/phoneNumber';

  /// 解绑第三方账号 → DELETE，返回 array（直返）
  static const String unbindThirdPart = '/api/user/thirdPart';

  /// 加绑微信 → POST，返回 array（直返）
  static const String bindWeixin = '/api/user/thirdPart/weixin';

  // ============ sport-history-controller（5 个） ============

  /// 运动数据查询/上传/删除 → GET/POST/DELETE
  static const String sportHistory = '/api/sport/data/history';

  /// 运动记录详情 → GET，返回 SportHistory（直返）
  static const String sportHistoryDetail = '/api/sport/data/history/detail';

  /// 多设备类型查询 → GET，返回 array<SportHistory>（直返）
  static const String sportHistoryMultiTypes = '/api/sport/data/history/multipleEquipmentTypes';

  // ============ sport-statistics-controller（9 个） ============

  /// 运动统计 → GET，返回 array<SportStatisticsDataResultDto>（直返）
  static const String sportStatistics = '/api/sport/statistics';

  /// 打卡日历 → GET，返回 array<string>（直返）
  static const String sportCalendar = '/api/sport/statistics/calendar';

  /// 卡路里排行榜 → GET，返回 ResultDto
  static const String caloriesLeaderboard = '/api/sport/statistics/caloriesLeaderboard';

  /// 特殊时间段统计 → GET，返回 array<SportStatisticsDataResultDto>（直返）
  static const String sportStatisticsSpecialTime = '/api/sport/statistics/specialTime';

  /// 新勋章 → GET，返回 array<MedalMsg>（直返）
  static const String newMedal = '/api/sport/statistics/user/medal/new';

  /// 勋章面板 → GET，返回 array<MedalGroup>（直返）
  static const String medalPanel = '/api/sport/statistics/user/medal/panel';

  /// 标记勋章已读 → PUT，返回 ResultDto
  static const String markMedalRead = '/api/sport/statistics/user/medal/read';

  /// 勋章总数 → GET，返回 int（直返）
  static const String medalTotalCount = '/api/sport/statistics/user/medal/totalCount';

  /// 用户排行榜信息 → GET，返回 ResultDto
  static const String userLeaderboardInfo = '/api/sport/statistics/userLeaderboardInfo';

  // ============ web-controller（2 个） ============

  /// Web 游戏排行榜 → GET/POST，返回 ResultDto
  static const String webRank = '/api/web/rank';

  // ============ 其他保留端点（旧项目使用） ============

  /// 下载图片
  static const String downLoadPicture = '/api/picture/path/';

  /// 下载压缩包
  static const String downLoadZipFile = '/api/picture/path/zip/';

  /// 排行榜用户头像（缩略图）
  static const String userPictureThumbnails = '/api/picture/path/thumbnails/';

  /// 排行榜用户头像
  static const String userPicture = '/api/picture/path/';

  /// Banner 推荐列表
  static const String recommendList = '/api/course/recommend/list';

  /// 版本检测
  static const String versionUpdate = '/api/course/version';

  /// 获取课程列表
  static const String courseList = '/api/course/list';

  /// 获取课程动作详情
  static const String courseAction = '/api/course/actions';

  /// 收藏课程
  static const String collectCourse = '/api/course/collect';

  /// 下载课程视频
  static const String downVideo = '/api/video/';

  /// 下载课程音频
  static const String downVoice = '/api/voice/';

  /// OTA 版本信息
  static const String otaVersion = 'https://cloud.capstong.com:8083/ota/deviceVersion/';

  /// OTA 文件下载
  static const String otaFile = 'https://cloud.capstong.com:8083/ota/file/';

  /// 上传数据到收集服务器
  static const String uploadTotalData = 'https://collector.ucfitness.club/collector/user/sport';

  /// 获取用户 devCode
  static const String userDevCode = 'https://collector.ucfitness.club/collector/user/devCode';

  /// WebSocket 地址
  static const String websocket = 'ws://www.ucfitness.club:8008/websocket/';

  /// 通义千问接口
  static const String onceChat = '/api/user/onceChat';

  // ============ 旧常量兼容别名（供旧 Repository 使用） ============

  static const String pwdLoginUrl = pwdLogin;
  static const String mailLoginUrl = mailLogin;
  static const String phoneLoginUrl = phoneLogin;
  static const String sendMailNumberUrl = sendMailVerCode;
  static const String sendPhoneNumberUrl = sendPhoneVerCode;
  static const String checkNumberUrl = checkVerCode;
  static const String checkBindMailUrl = checkBindMail;
  static const String updatePwdUrl = updatePassword;
  static const String refreshTokenUrl = refreshToken;
  static const String signOutUrl = signOut;
  static const String getStatisticsUrl = sportStatistics;
  static const String getStatisticsCalendarUrl = sportCalendar;
}
