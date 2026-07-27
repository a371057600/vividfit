# Dio 网络模块重构 - Product Requirement Document

## Overview
- **Summary**: 将现有 `ApiService` 彻底重构为类型安全、与 Riverpod 深度集成、具备完整日志与统一异常体系的现代 Dio 网络层模块。新建 `lib/core/network/` 目录，包含 ApiResponse/ApiException 类型、拦截器链（日志/认证/错误）、DioClient、ApiClient、Riverpod Providers。同步迁移 Auth/Home/Course 三个 Repository 并删除旧 ApiService。
- **Purpose**: 解决当前 ApiService 行为不一致（部分吞异常/部分抛异常）、无类型安全、Token 管理手动化、无日志、Dio 实例分散等核心问题，建立可复用、可测试、与 Riverpod 架构一致的网络基础设施。
- **Target Users**: viviFit v2 项目开发团队，所有需要发起网络请求的业务模块。

## Goals
- 建立统一的 `ApiResponse<T>` 类型，所有后端响应以同一格式解析
- 建立统一的 `ApiException` 异常体系，网络层错误类型单一可控
- 实现类型安全的 `ApiClient`，支持泛型 `get<T>/post<T>/put<T>`
- 通过拦截器实现请求/响应/错误全链路 `print` 日志（release 模式可观测）
- 通过 `AuthInterceptor` 实现 Token 自动附加，无需手动 updateAccessToken
- 通过 Riverpod Providers 注入网络依赖，与现有架构风格一致
- 迁移 Auth/Home/Course 三个 Repository 至新网络层
- 提供完整单元测试覆盖（响应解析、异常、拦截器、ApiClient）
- API 常量从完整 URL 改为 path 形式，baseUrl 统一由 DioClient 管理

## Non-Goals (Out of Scope)
- 不引入 Retrofit 或其他代码生成网络框架
- 不实现多环境 baseUrl 切换（dev/staging/prod），后续由 i18n 模块统一处理
- 不实现缓存层（本地缓存由 Repository 层或单独模块负责）
- 不实现 WebSocket / SSE 等长连接能力
- 不修改现有业务逻辑（仅替换网络层实现，保持接口返回值与行为一致）
- 不新增业务接口（只接入 CourseRepository 假数据占位的现有接口）

## Background & Context
- 现有 `ApiService`（`lib/core/services/api_service.dart`）是从旧项目 1:1 迁移的 Dio 封装，存在行为不一致问题：`post/get/put` 吞异常返回 `{'error': ...}`，而 `authedGet/authedPut` 直接抛 DioException
- Token 通过构造时读取并保存到 header，登录后必须手动调用 `updateAccessToken`，存在遗漏风险
- 无统一日志机制，不符合"所有数据上传流程需 print 监测"的工程规范
- Repository 层（Auth/Home/Course）各自解析 `code == '200'`，重复劳动且易错
- 项目技术栈：Flutter 3.44 / Dart 3.12 / flutter_riverpod ^3.4.1 / dio ^5.11.0 / mocktail ^1.0.4
- 后端响应格式：`{ code: "200", data: {...}, message: "..." }`，code 为字符串
- 认证方式：请求头 `app_pass`（固定值 Chuan1212）+ `access_token`（登录后获取）

## Functional Requirements
- **FR-1**: ApiResponse<T> 类型包装后端响应，含 code/message/data/isSuccess 属性及 fromJson 工厂构造
- **FR-2**: ApiException 统一异常类型，含 code/message/rawError 及 isUnauthorized/isNetworkError/isServerError 便捷判断
- **FR-3**: ApiResponse.getOrThrow() 扩展方法，业务失败时自动抛 ApiException
- **FR-4**: LoggingInterceptor — onRequest/onResponse/onError 全链路 print 输出请求方法、URL、headers、body、状态码、响应数据、错误类型
- **FR-5**: AuthInterceptor — 每次请求实时从 StorageService 读取 access_token，自动附加 app_pass 和 access_token header
- **FR-6**: ErrorInterceptor — 将 DioException 转换为 ApiException（区分 401/5xx/超时/网络断开/其他）
- **FR-7**: DioClient — 单一 Dio 实例管理，配置 baseUrl/超时/响应类型，按序注册拦截器链
- **FR-8**: ApiClient — 类型安全泛型请求方法（get/post/put/delete），返回 ApiResponse<T>
- **FR-9**: Riverpod Providers — dioClientProvider 与 apiClientProvider
- **FR-10**: ApiConstants 重构 — URL 常量从完整 URL 改为 path 形式
- **FR-11**: AuthRepository 迁移 — 使用 ApiClient，保持方法签名不变
- **FR-12**: HomeRepository 迁移 — 使用 ApiClient，保持方法签名不变
- **FR-13**: CourseRepository 迁移 — 接入真实接口（移除假数据占位）
- **FR-14**: 删除旧 ApiService 及 apiServiceProvider

## Non-Functional Requirements
- **NFR-1 (可测试性)**: 网络模块核心组件（响应解析、异常、拦截器、ApiClient）均有单元测试，测试覆盖率覆盖主要分支（成功/失败/超时/网络错误/401）
- **NFR-2 (Riverpod 兼容)**: 通过 Provider 注入，与现有 Riverpod 3.x 无代码生成风格一致
- **NFR-3 (向后兼容)**: Repository 层方法签名与返回类型保持不变，上层 Notifier/UI 代码零修改
- **NFR-4 (代码质量)**: flutter analyze 0 errors 0 warnings
- **NFR-5 (日志可观测)**: release 模式下所有请求/响应/错误均可通过 print 输出监测

## Constraints
- **Technical**: 
  - Flutter 3.44 / Dart 3.12
  - dio ^5.11.0
  - flutter_riverpod ^3.4.1（无代码生成，手动 Provider 定义）
  - mocktail ^1.0.4（单元测试 mock）
  - 不新增依赖
- **Business**:
  - 保持现有业务行为不变，仅替换网络层实现
  - CourseRepository 接入真实接口（原假数据占位）
- **Dependencies**:
  - StorageService（SharedPreferences 封装）
  - ApiConstants（API 端点常量）
  - LoginResponse / FitStatsData / CourseList / CourseDetail 等现有数据模型

## Assumptions
- 后端响应格式始终为 `{ code, data, message }` JSON 对象，code 为字符串类型
- `app_pass` 固定值 `Chuan1212` 不变
- access_token 存储在 StorageService.accessToken（SharedPreferences）
- 现有 Repository 的方法签名与返回类型是稳定的，重构不改变它们
- 拦截器执行顺序为：Logging → Auth → Error（请求方向），Error → Logging（响应方向）

## Acceptance Criteria

### AC-1: ApiResponse 正确解析成功/失败响应
- **Given**: 后端返回标准 JSON 响应
- **When**: 调用 ApiResponse.fromJson 解析
- **Then**: code/message/data 属性正确赋值，isSuccess 在 code=="200" 时为 true
- **Verification**: `programmatic`

### AC-2: getOrThrow 正确抛出/返回
- **Given**: ApiResponse 实例
- **When**: 调用 getOrThrow()
- **Then**: 成功且 data 非空时返回 data；code 非 200 或 data 为 null 时抛 ApiException
- **Verification**: `programmatic`

### AC-3: ApiException 类型判断正确
- **Given**: 不同 code 的 ApiException 实例
- **When**: 访问 isUnauthorized / isNetworkError / isServerError
- **Then**: 属性值与 code 对应正确（401→Unauthorized，NETWORK_ERROR→NetworkError，SERVER_ERROR→ServerError）
- **Verification**: `programmatic`

### AC-4: 日志拦截器输出完整信息
- **Given**: Dio 请求/响应/错误发生
- **When**: LoggingInterceptor 触发
- **Then**: print 输出包含方法/URL/headers/body（请求）、状态码/数据（响应）、错误类型/消息（错误）
- **Verification**: `programmatic`

### AC-5: AuthInterceptor 正确附加 Token
- **Given**: StorageService 中有/无 access_token
- **When**: 发起请求
- **Then**: 有 token 时同时附加 app_pass 和 access_token header；无 token 时只附加 app_pass
- **Verification**: `programmatic`

### AC-6: ErrorInterceptor 正确转换异常
- **Given**: 不同类型的 DioException（401响应/500响应/超时/网络断开/badResponse）
- **When**: ErrorInterceptor.onError 触发
- **Then**: 转换为对应 code 的 ApiException（401/SERVER_ERROR/TIMEOUT/NETWORK_ERROR/HTTP状态码）
- **Verification**: `programmatic`

### AC-7: ApiClient get/post/put 返回类型安全结果
- **Given**: Mock Dio 返回成功/失败 JSON
- **When**: 调用 apiClient.get/post/put
- **Then**: 返回 ApiResponse<T>，泛型类型正确，isSuccess 与后端 code 一致
- **Verification**: `programmatic`

### AC-8: ApiClient 网络错误抛 ApiException
- **Given**: Dio 抛出连接异常
- **When**: 调用 apiClient.get
- **Then**: 抛出 ApiException（而非 DioException）
- **Verification**: `programmatic`

### AC-9: Riverpod Provider 正确注入
- **Given**: ProviderScope 环境
- **When**: 读取 apiClientProvider
- **Then**: 获取到 ApiClient 实例，内部 Dio 配置了正确的 baseUrl 和拦截器链
- **Verification**: `human-judgment`
- **Notes**: 代码审查 Provider 定义与依赖关系

### AC-10: AuthRepository 迁移后行为一致
- **Given**: 迁移后的 AuthRepository
- **When**: 调用 login / sendEmailCaptcha / checkBindMail 等方法
- **Then**: 返回值类型与原方法一致，功能行为不变
- **Verification**: `programmatic`
- **Notes**: 确保方法签名与返回类型未变；现有调用方零修改

### AC-11: HomeRepository 迁移后行为一致
- **Given**: 迁移后的 HomeRepository
- **When**: 调用 getSportStatistics / refreshToken / signOut 等方法
- **Then**: 返回值类型与原方法一致，功能行为不变
- **Verification**: `programmatic`

### AC-12: CourseRepository 接入真实接口
- **Given**: 迁移后的 CourseRepository
- **When**: 调用 getCourseList / getCourseDetail
- **Then**: 发起真实网络请求并解析为对应模型类型（而非返回假数据）
- **Verification**: `programmatic`

### AC-13: 旧 ApiService 完全移除
- **Given**: 重构完成后的代码库
- **When**: 全局搜索 ApiService / apiServiceProvider
- **Then**: 无任何匹配，所有引用均已替换
- **Verification**: `programmatic`

### AC-14: flutter analyze 零问题
- **Given**: 重构完成后的代码库
- **When**: 运行 flutter analyze
- **Then**: 0 errors, 0 warnings
- **Verification**: `programmatic`

### AC-15: flutter test 全部通过
- **Given**: 重构完成后的代码库
- **When**: 运行 flutter test
- **Then**: 所有现有测试 + 新增网络层测试全部通过
- **Verification**: `programmatic`

## Open Questions
- 无（需求明确，基于现有代码重构）
