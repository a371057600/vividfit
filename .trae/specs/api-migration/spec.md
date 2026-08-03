# 业务接口迁移 - Product Requirement Document

## Overview
- **Summary**: 基于 Swagger 文档（`code.vividfit.cn`）将全部业务接口迁移到 vividfit_v2 项目。完成地址常量更新、Dio 网络模块完善（支持两种响应格式）、数据模型创建、API 服务类实现，并提供实机测试页面用于手动验证接口 JSON 数据传递。
- **Purpose**: 旧版本 API 接口地址、app_pass、响应格式与新后端不兼容，需要全量迁移以确保 app 能正常与服务器通信。
- **Target Users**: 开发者和测试人员，通过实机测试页面验证每个接口的正确性。

## Goals
- 更新 `ApiConstants` 配置新 baseUrl (`code.vividfit.cn`) 和 app_pass (`rido1234`)
- 完善 `ApiClient` 支持两种响应格式：ResultDto 包装型 + 直接返回型
- 基于 Swagger 文档创建所有数据模型（Freezed）
- 创建按 Controller 分组的 5 个 API 服务类（PublicApi、UserApi、SportHistoryApi、SportStatisticsApi、WebApi）
- 每个 API 方法都有 print 日志输出，便于调试
- 处理图片 URL：头像和勋章图片是阿里云 OSS 直接下载链接，使用 `Image.network()` 直接加载
- 创建 `ApiTestPage` 实机测试页面，支持点击按钮测试所有 36 个接口
- 全项目使用 Riverpod 3.x `@Riverpod` 注解 + `.g.dart` 代码生成

## Non-Goals (Out of Scope)
- **不修改业务逻辑层**（Repository、Notifier），新的 API 服务类作为独立工具层存在
- **不替换现有登录流程**，旧的 `ApiService` 继续工作
- **不实现勋章页面 UI**（仅创建测试页面验证接口数据）
- **不处理课程模块的图片**（课程封面等暂保留旧 API 方式）
- **不添加单元测试**，接口测试通过实机测试页面手动完成

## Background & Context
- 旧项目 `vividfit` 使用 `https://www.ucfitness.club` 和 `app_pass = Chuan1212`
- 新项目后端迁移到 `https://code.vividfit.cn`，`app_pass = rido1234`
- 旧后端响应格式不统一，新后端使用标准 `ResultDto`：`{code: "200", msg: "ok", data: ...}`
- 部分接口直接返回数据（不是 ResultDto 包装），需要 `ApiClient` 同时支持两种格式
- 图片资源存储在阿里云 OSS，URL 是完整的 https 链接，无需 API 拼接
- Swagger 文档定义了 5 个 Controller（public、user、sport-history、sport-statistics、web）共 36 个端点

## Functional Requirements
- **FR-1**: `ApiConstants` 必须包含新的 baseUrl、app_pass 常量，以及所有 36 个端点的路径常量
- **FR-2**: `ApiClient` 必须支持 `get/post/put/delete`（ResultDto 包装型）和 `getRaw/postRaw/putRaw/deleteRaw`（直接返回型）两种调用方式
- **FR-3**: `ApiResponse` 字段对齐 Swagger ResultDto 规范，使用 `msg` 而非 `message`
- **FR-4**: 创建以下数据模型：SportHistory、SportHistoryDto、SportStatisticsDataResultDto、MedalMsg、MedalGroup、ReadMedal、ThirdPartyUser、VipInfo、WebRankDto、UserInfoDto、UserInfoResultDto
- **FR-5**: LoginResponse 模型需包含 `thirdPartInfos` 和 `vipInfo` 字段
- **FR-6**: 5 个 API 服务类按 Controller 分组，每个方法都有 print 日志（📤 请求、📥 响应、❌ 错误）
- **FR-7**: `ApiTestPage` 提供 36 个接口测试按钮，点击执行请求并在页面和调试窗口显示结果
- **FR-8**: 头像图片 URL 是完整 OSS 链接，直接使用 `Image.network()` 加载
- **FR-9**: 勋章图片 URL 是完整 OSS 链接，使用 `Image.network()` 加载，需有 errorWidget fallback
- **FR-10**: 所有 Provider 使用 `@Riverpod(keepAlive: true)` 注解 + `part` 声明 + build_runner 代码生成

## Non-Functional Requirements
- **NFR-1**: 网络模块必须独立，不引入任何业务 API 调用（纯基础设施）
- **NFR-2**: 所有网络请求必须通过 print 输出请求参数、响应状态码、完整响应体
- **NFR-3**: 代码风格遵循全项目 Riverpod 3.x 规范（@Riverpod 注解 + .g.dart）
- **NFR-4**: Freezed 3.x 语法（`abstract class` + `@freezed` 注解）
- **NFR-5**: 图片加载使用 `Image.network` / `Image.asset`，不使用 `ExtendedImage`
- **NFR-6**: flutter analyze 必须 0 errors，flutter test 必须全部通过

## Constraints
- **Technical**: Flutter 3.44.0, Dart 3.12.0, Dio, Freezed 3.x, Riverpod 3.x
- **Business**: 不修改现有业务层代码，新 API 层作为独立模块
- **Dependencies**: Swagger 文档是唯一接口规范来源

## Assumptions
- Swagger 文档中的接口定义是准确的，字段名、类型、响应格式以 Swagger 为准
- 新后端的 ResultDto 响应格式为 `{code: string, msg: string, data: T}`
- 需要 app_pass 的接口通过请求头传递（key: `app_pass`，value: `rido1234`）
- 需要 access_token 的接口通过请求头传递（key: `access_token`，value: token 值）
- 图片 URL 均为完整的 https OSS 链接，可直接访问
- 服务器在实施期间保持可用

## Acceptance Criteria

### AC-1: ApiConstants 更新正确
- **Given**: 项目初始化
- **When**: 检查 `lib/core/constants/api_constants.dart`
- **Then**: baseUrl 为 `https://code.vividfit.cn`，appPass 为 `rido1234`，36 个端点路径已定义
- **Verification**: `programmatic`
- **Notes**: flutter analyze 通过

### AC-2: ApiClient 支持两种响应格式
- **Given**: ApiClient 实例
- **When**: 调用 `get/post/put/delete` 方法请求 ResultDto 包装型接口
- **Then**: 返回 `ApiResponse<T>` 对象，`code`、`msg`、`data` 字段正确解析
- **Verification**: `programmatic`

### AC-3: ApiClient 支持直接返回型接口
- **Given**: ApiClient 实例
- **When**: 调用 `getRaw/postRaw/putRaw/deleteRaw` 方法请求直接返回型接口
- **Then**: 返回解析后的模型对象，不经过 ResultDto 包装
- **Verification**: `programmatic`

### AC-4: 数据模型创建完成
- **Given**: 项目代码
- **When**: 检查 `lib/data/models/network/` 目录
- **Then**: 存在 11 个数据模型文件，通过 Freezed 代码生成，无编译错误
- **Verification**: `programmatic`
- **Notes**: build_runner 生成成功，flutter analyze 通过

### AC-5: API 服务类实现完成
- **Given**: 项目代码
- **When**: 检查 `lib/data/api/` 目录
- **Then**: 存在 5 个 API 服务类，每个方法都有 print 日志
- **Verification**: `human-judgment`
- **Notes**: 检查日志输出格式：📤 请求、📥 响应、❌ 错误

### AC-6: Riverpod Provider 使用 @Riverpod 注解
- **Given**: 项目代码
- **When**: 检查 `network_providers.dart` 和 `api_providers.dart`
- **Then**: 使用 `@Riverpod(keepAlive: true)` 注解，有 `part` 声明，有 `.g.dart` 文件
- **Verification**: `programmatic`

### AC-7: 实机测试页面可用
- **Given**: 应用运行在 debug 模式
- **When**: 从登录页点击 "API 测试页" 按钮
- **Then**: 跳转到 ApiTestPage，页面显示所有接口测试按钮
- **Verification**: `human-judgment`

### AC-8: 接口测试输出完整日志
- **Given**: ApiTestPage 打开
- **When**: 点击任意接口测试按钮
- **Then**: 调试窗口 print 输出请求参数、响应状态码、完整 JSON 数据
- **Verification**: `human-judgment`

### AC-9: flutter analyze 无错误
- **Given**: 所有代码修改完成
- **When**: 运行 `fvm dart analyze`
- **Then**: 0 errors, 0 warnings
- **Verification**: `programmatic`

### AC-10: flutter test 全部通过
- **Given**: 所有代码修改完成
- **When**: 运行 `fvm flutter test`
- **Then**: 所有测试通过
- **Verification**: `programmatic`

## Open Questions
- [ ] 部分 Swagger 接口的请求/响应字段细节（如特殊类型转换）可能需要在实机测试中验证
- [ ] 课程封面等非头像/勋章图片是否也使用新的 OSS 链接格式？（当前假设保留旧 API 方式）
