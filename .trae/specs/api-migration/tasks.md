# 业务接口迁移 - The Implementation Plan (Decomposed and Prioritized Task List)

## [x] Task 1: 更新 ApiConstants — 迁移地址常量
- **Priority**: high
- **Depends On**: None
- **Description**: 
  - 更新 `lib/core/constants/api_constants.dart` 中的 baseUrl 为 `https://code.vividfit.cn`
  - 更新 appPass 为 `rido1234`
  - 所有端点改为 path-only 格式（如 `/api/public/login/pwd`）
  - 新增 Swagger 定义的端点（共 36 个）
  - 保留旧项目使用的非 Swagger 端点（课程、OTA 等）
- **Acceptance Criteria Addressed**: AC-1
- **Test Requirements**:
  - `programmatic` TR-1.1: flutter analyze 通过，0 errors
  - `programmatic` TR-1.2: baseUrl = `https://code.vividfit.cn`
  - `programmatic` TR-1.3: appPass = `rido1234`
  - `programmatic` TR-1.4: 36 个 Swagger 端点路径已定义
- **Notes**: 参考 v2 计划文档 Task 1 的完整代码

## [x] Task 2: 完善 ApiResponse + ApiClient 支持两种响应格式
- **Priority**: high
- **Depends On**: Task 1
- **Description**: 
  - `ApiResponse` 字段 `message` → `msg` 对齐 Swagger ResultDto
  - `ApiResponseExtension` 同步更新
  - `ApiClient` 新增 `getRaw/postRaw/putRaw/deleteRaw` 方法支持直接返回型响应
  - 所有请求/响应通过 print 输出日志
- **Acceptance Criteria Addressed**: AC-2, AC-3
- **Test Requirements**:
  - `programmatic` TR-2.1: flutter analyze 通过
  - `programmatic` TR-2.2: 现有测试中 `.message` 改为 `.msg` 后通过
  - `programmatic` TR-2.3: `getRaw/postRaw/putRaw/deleteRaw` 方法存在且签名正确
- **Notes**: 参考 v2 计划文档 Task 2

## [x] Task 3: 修复 network_providers.dart — 使用 @Riverpod 注解
- **Priority**: high
- **Depends On**: Task 2
- **Description**: 
  - 确保 `network_providers.dart` 使用 `@Riverpod(keepAlive: true)` 注解
  - 确保有 `part 'network_providers.g.dart'` 声明
  - 运行 build_runner 生成 `.g.dart` 文件
- **Acceptance Criteria Addressed**: AC-6
- **Test Requirements**:
  - `programmatic` TR-3.1: `@Riverpod(keepAlive: true)` 注解存在
  - `programmatic` TR-3.2: `part` 声明存在
  - `programmatic` TR-3.3: `.g.dart` 文件已生成
  - `programmatic` TR-3.4: flutter analyze 通过
- **Notes**: 当前代码已基本符合要求，需验证并可能调整

## [x] Task 4: 创建数据模型（SportHistory + SportHistoryDto）
- **Priority**: high
- **Depends On**: Task 1
- **Description**: 
  - 创建 `lib/data/models/network/sport_history.dart`
  - 定义 `SportHistory`（查询返回）和 `SportHistoryDto`（上传请求体）
  - 使用 Freezed 3.x 语法
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-4.1: build_runner 生成成功
  - `programmatic` TR-4.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 4

## [x] Task 5: 创建数据模型（SportStatisticsDataResultDto）
- **Priority**: high
- **Depends On**: Task 1
- **Description**: 
  - 创建 `lib/data/models/network/sport_statistics_dto.dart`
  - 定义 `SportStatisticsDataResultDto`
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-5.1: build_runner 生成成功
  - `programmatic` TR-5.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 5

## [x] Task 6: 创建数据模型（MedalMsg + MedalGroup + ReadMedal）
- **Priority**: high
- **Depends On**: Task 1
- **Description**: 
  - 创建 `lib/data/models/network/medal.dart`
  - 定义 `MedalMsg`、`MedalGroup`、`ReadMedal`
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-6.1: build_runner 生成成功
  - `programmatic` TR-6.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 6

## [x] Task 7: 创建数据模型（ThirdPartyUser + VipInfo）
- **Priority**: high
- **Depends On**: Task 1
- **Description**: 
  - 创建 `lib/data/models/network/third_party_user.dart`
  - 创建 `lib/data/models/network/vip_info.dart`
  - 定义 `ThirdPartyUser`、`VipInfo`
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-7.1: build_runner 生成成功
  - `programmatic` TR-7.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 7

## [x] Task 8: 创建数据模型（WebRankDto + UserInfoDto + UserInfoResultDto）
- **Priority**: high
- **Depends On**: Task 1, Task 7
- **Description**: 
  - 创建 `lib/data/models/network/web_rank_dto.dart`
  - 创建 `lib/data/models/network/user_info_dto.dart`
  - `UserInfoResultDto` 引用 `ThirdPartyUser`
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-8.1: build_runner 生成成功
  - `programmatic` TR-8.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 8

## [x] Task 9: 更新 LoginResponse 模型
- **Priority**: high
- **Depends On**: Task 7
- **Description**: 
  - 更新 `lib/data/models/login_response.dart`
  - `LoginData` 新增 `thirdPartInfos` 和 `vipInfo` 字段
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-9.1: build_runner 生成成功
  - `programmatic` TR-9.2: flutter analyze 通过
  - `programmatic` TR-9.3: 现有测试通过
- **Notes**: 参考 v2 计划文档 Task 9

## [x] Task 10: 创建 PublicApi 服务
- **Priority**: high
- **Depends On**: Task 1, Task 2, Task 9
- **Description**: 
  - 创建 `lib/data/api/public_api.dart`
  - 实现 11 个 public-controller 端点
  - 每个方法都有 print 日志
- **Acceptance Criteria Addressed**: AC-5
- **Test Requirements**:
  - `human-judgment` TR-10.1: 检查代码，每个方法有 📤📥❌ 日志
  - `programmatic` TR-10.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 10

## [x] Task 11: 创建 UserApi 服务
- **Priority**: high
- **Depends On**: Task 1, Task 2, Task 8
- **Description**: 
  - 创建 `lib/data/api/user_api.dart`
  - 实现 9 个 user-controller 端点
  - 每个方法都有 print 日志
  - 头像图片使用 `Image.network()` 直接加载
- **Acceptance Criteria Addressed**: AC-5
- **Test Requirements**:
  - `human-judgment` TR-11.1: 检查代码，每个方法有 📤📥❌ 日志
  - `programmatic` TR-11.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 11

## [x] Task 12: 创建 SportHistoryApi 服务
- **Priority**: high
- **Depends On**: Task 1, Task 2, Task 4
- **Description**: 
  - 创建 `lib/data/api/sport_history_api.dart`
  - 实现 5 个 sport-history-controller 端点
  - 每个方法都有 print 日志
- **Acceptance Criteria Addressed**: AC-5
- **Test Requirements**:
  - `human-judgment` TR-12.1: 检查代码，每个方法有 📤📥❌ 日志
  - `programmatic` TR-12.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 12

## [x] Task 13: 创建 SportStatisticsApi 服务
- **Priority**: high
- **Depends On**: Task 1, Task 2, Task 5, Task 6
- **Description**: 
  - 创建 `lib/data/api/sport_statistics_api.dart`
  - 实现 9 个 sport-statistics-controller 端点
  - 每个方法都有 print 日志
  - 勋章图片使用 `Image.network()` 直接加载
- **Acceptance Criteria Addressed**: AC-5
- **Test Requirements**:
  - `human-judgment` TR-13.1: 检查代码，每个方法有 📤📥❌ 日志
  - `programmatic` TR-13.2: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 13

## [x] Task 14: 创建 WebApi 服务 + API Providers
- **Priority**: high
- **Depends On**: Task 1, Task 2, Task 3
- **Description**: 
  - 创建 `lib/data/api/web_api.dart`
  - 创建 `lib/data/api/api_providers.dart`
  - 5 个 Provider 均使用 `@Riverpod(keepAlive: true)` 注解
  - 运行 build_runner 生成 `.g.dart`
- **Acceptance Criteria Addressed**: AC-5, AC-6
- **Test Requirements**:
  - `programmatic` TR-14.1: build_runner 生成成功
  - `programmatic` TR-14.2: flutter analyze 通过
  - `programmatic` TR-14.3: 5 个 Provider 使用 @Riverpod 注解
- **Notes**: 参考 v2 计划文档 Task 14

## [x] Task 15: 创建实机 API 测试页面
- **Priority**: high
- **Depends On**: Task 10, Task 11, Task 12, Task 13, Task 14
- **Description**: 
  - 创建 `lib/features/dev/api_test_page.dart`
  - 包含所有 36 个接口的测试按钮
  - 点击执行请求，结果显示在页面和调试窗口
  - 头像/勋章图片测试使用 `Image.network()`
  - 支持 userId、账号、密码输入
- **Acceptance Criteria Addressed**: AC-7, AC-8
- **Test Requirements**:
  - `human-judgment` TR-15.1: 页面布局合理，按钮分组清晰
  - `human-judgment` TR-15.2: 点击按钮后请求执行，结果显示
  - `human-judgment` TR-15.3: 调试窗口有完整 print 日志
  - `programmatic` TR-15.4: flutter analyze 通过
- **Notes**: 参考 v2 计划文档 Task 15

## [x] Task 16: 添加路由 + 最终验证
- **Priority**: high
- **Depends On**: Task 15
- **Description**: 
  - 在 `app_router.dart` 添加 `/api-test` 路由
  - 在 `login_page.dart` 添加 "API 测试页" 按钮（仅 debug 模式）
  - 运行全量 flutter analyze 和 flutter test
- **Acceptance Criteria Addressed**: AC-9, AC-10
- **Test Requirements**:
  - `programmatic` TR-16.1: flutter analyze 0 errors
  - `programmatic` TR-16.2: flutter test 全部通过
  - `human-judgment` TR-16.3: 从登录页可点击进入测试页面
- **Notes**: 参考 v2 计划文档 Task 16
