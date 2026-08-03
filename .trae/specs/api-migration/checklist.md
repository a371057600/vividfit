# 业务接口迁移 - Verification Checklist

## 基础设施层
- [x] Checkpoint 1: `api_constants.dart` 中 baseUrl 为 `https://code.vividfit.cn`，appPass 为 `rido1234`
- [x] Checkpoint 2: 36 个 Swagger 端点路径已定义（path-only 格式）
- [x] Checkpoint 3: `ApiResponse` 使用 `msg` 字段（非 `message`）
- [x] Checkpoint 4: `ApiClient` 有 `getRaw/postRaw/putRaw/deleteRaw` 方法
- [x] Checkpoint 5: `ApiClient` 的 `get/post/put/delete` 方法返回 `ApiResponse<T>`
- [x] Checkpoint 6: `network_providers.dart` 使用 `@Riverpod(keepAlive: true)` 注解 + `part` 声明
- [x] Checkpoint 7: `network_providers.g.dart` 已生成且无编译错误
- [x] Checkpoint 8: `api_providers.dart` 使用 `@Riverpod(keepAlive: true)` 注解 + `part` 声明
- [x] Checkpoint 9: `api_providers.g.dart` 已生成且无编译错误

## 数据模型层
- [x] Checkpoint 10: `sport_history.dart` 定义了 `SportHistory` 和 `SportHistoryDto`
- [x] Checkpoint 11: `sport_statistics_dto.dart` 定义了 `SportStatisticsDataResultDto`
- [x] Checkpoint 12: `medal.dart` 定义了 `MedalMsg`、`MedalGroup`、`ReadMedal`
- [x] Checkpoint 13: `third_party_user.dart` 定义了 `ThirdPartyUser`
- [x] Checkpoint 14: `vip_info.dart` 定义了 `VipInfo`
- [x] Checkpoint 15: `web_rank_dto.dart` 定义了 `WebRankDto`
- [x] Checkpoint 16: `user_info_dto.dart` 定义了 `UserInfoDto` 和 `UserInfoResultDto`
- [x] Checkpoint 17: `login_response.dart` 中 `LoginData` 包含 `thirdPartInfos` 和 `vipInfo` 字段
- [x] Checkpoint 18: 所有模型通过 Freezed 代码生成，`.freezed.dart` 和 `.g.dart` 文件存在

## API 服务层
- [x] Checkpoint 19: `PublicApi` 实现了 11 个端点，每个方法有 print 日志
- [x] Checkpoint 20: `UserApi` 实现了 9 个端点，每个方法有 print 日志
- [x] Checkpoint 21: `SportHistoryApi` 实现了 5 个端点，每个方法有 print 日志
- [x] Checkpoint 22: `SportStatisticsApi` 实现了 9 个端点，每个方法有 print 日志
- [x] Checkpoint 23: `WebApi` 实现了 2 个端点，每个方法有 print 日志
- [x] Checkpoint 24: 所有 API 方法日志格式统一（📤 请求、📥 响应、❌ 错误）
- [x] Checkpoint 25: ResultDto 包装型接口使用 `ApiClient.get/post/put/delete`
- [x] Checkpoint 26: 直接返回型接口使用 `ApiClient.getRaw/postRaw/putRaw/deleteRaw`

## 图片处理
- [x] Checkpoint 27: 头像图片 URL 为完整 OSS 链接时使用 `Image.network()` 直接加载
- [x] Checkpoint 28: 勋章图片 URL 为完整 OSS 链接时使用 `Image.network()` 直接加载
- [x] Checkpoint 29: 图片加载有 errorWidget fallback
- [x] Checkpoint 30: 未使用 `ExtendedImage`（统一用 `Image.network` / `Image.asset`）

## 测试页面
- [x] Checkpoint 31: `ApiTestPage` 按 Controller 分组显示所有接口测试按钮
- [x] Checkpoint 32: 支持 userId、账号、密码输入
- [x] Checkpoint 33: 点击按钮后请求执行，结果显示在页面文本框中
- [x] Checkpoint 34: 调试窗口 print 输出完整的请求参数、响应状态码、JSON 数据
- [x] Checkpoint 35: 支持从登录页进入测试页面（debug 模式）
- [x] Checkpoint 36: `/api-test` 路由配置正确

## 代码质量
- [x] Checkpoint 37: `fvm dart analyze` 0 errors, 0 warnings
- [ ] Checkpoint 38: `fvm flutter test` 所有测试通过（4 个预存失败：notifier 测试引用不存在的 provider 文件）
- [x] Checkpoint 39: 无多余 import，无 dead code
- [x] Checkpoint 40: 新代码不破坏现有业务层（Repository、Notifier 不受影响）
