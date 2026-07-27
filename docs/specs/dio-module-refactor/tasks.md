# Dio 网络模块重构 - The Implementation Plan (Decomposed and Prioritized Task List)

## [x] Task 1: ApiResponse + ApiException 基础类型
- **Priority**: high
- **Depends On**: None
- **Description**: 
  - 创建 `lib/core/network/api_response.dart`，实现 `ApiResponse<T>` 泛型类，含 code/message/data/isSuccess 属性及 fromJson 工厂构造
  - 创建 `lib/core/network/api_exception.dart`，实现 `ApiException` 异常类，含 code/message/rawError 及 isUnauthorized/isNetworkError/isServerError 属性
  - 创建 `lib/core/network/api_response_extension.dart`，实现 `getOrThrow()` 扩展方法
  - 编写对应单元测试（api_response_test.dart + api_exception_test.dart）
- **Acceptance Criteria Addressed**: AC-1, AC-2, AC-3
- **Test Requirements**:
  - `programmatic` TR-1.1: ApiResponse.fromJson 正确解析成功响应（code=200, 有 data, 有 message）
  - `programmatic` TR-1.2: ApiResponse.fromJson 正确解析失败响应（code=500, 无 data）
  - `programmatic` TR-1.3: ApiResponse.fromJson 处理 data 为 null 的情况
  - `programmatic` TR-1.4: getOrThrow() 在成功且 data 非空时返回 data
  - `programmatic` TR-1.5: getOrThrow() 在 code 非 200 时抛 ApiException
  - `programmatic` TR-1.6: getOrThrow() 在 data 为 null 时抛 ApiException
  - `programmatic` TR-1.7: ApiException 的 isUnauthorized/isNetworkError/isServerError 判断正确
  - `programmatic` TR-1.8: flutter test 对应测试全部通过

## [x] Task 2: 三个拦截器实现
- **Priority**: high
- **Depends On**: Task 1
- **Description**:
  - 创建 `lib/core/network/interceptors/logging_interceptor.dart`，实现 onRequest/onResponse/onError 全链路 print 日志
  - 创建 `lib/core/network/interceptors/auth_interceptor.dart`，实时读取 StorageService.accessToken，自动附加 app_pass + access_token header
  - 创建 `lib/core/network/interceptors/error_interceptor.dart`，将 DioException 转换为 ApiException（区分 401/5xx/超时/网络断开/其他）
  - 编写对应单元测试（logging_interceptor_test.dart + auth_interceptor_test.dart + error_interceptor_test.dart）
- **Acceptance Criteria Addressed**: AC-4, AC-5, AC-6
- **Test Requirements**:
  - `programmatic` TR-2.1: LoggingInterceptor.onRequest 调用 handler.next
  - `programmatic` TR-2.2: LoggingInterceptor.onResponse 调用 handler.next
  - `programmatic` TR-2.3: LoggingInterceptor.onError 调用 handler.next
  - `programmatic` TR-2.4: AuthInterceptor 在有 token 时附加 app_pass + access_token 两个 header
  - `programmatic` TR-2.5: AuthInterceptor 在 token 为 null 时只附加 app_pass
  - `programmatic` TR-2.6: AuthInterceptor 在 token 为空字符串时只附加 app_pass
  - `programmatic` TR-2.7: ErrorInterceptor 将 401 响应转为 code='401' 的 ApiException
  - `programmatic` TR-2.8: ErrorInterceptor 将 5xx 响应转为 code='SERVER_ERROR' 的 ApiException
  - `programmatic` TR-2.9: ErrorInterceptor 将超时转为 code='TIMEOUT' 的 ApiException
  - `programmatic` TR-2.10: ErrorInterceptor 将连接错误转为 code='NETWORK_ERROR' 的 ApiException
  - `programmatic` TR-2.11: ErrorInterceptor 从响应体读取 message/msg 字段作为错误消息
  - `programmatic` TR-2.12: flutter test 对应测试全部通过

## [x] Task 3: DioClient + ApiClient 类型安全封装
- **Priority**: high
- **Depends On**: Task 1, Task 2
- **Description**:
  - 创建 `lib/core/network/dio_client.dart`，管理单一 Dio 实例，配置 baseUrl/超时/响应类型，注册拦截器链
  - 创建 `lib/core/network/api_client.dart`，实现类型安全泛型请求（get<T>/post<T>/put<T>/delete<T>），返回 ApiResponse<T>
  - 编写 api_client_test.dart 单元测试（Mock Dio，覆盖成功/失败/网络错误/非 JSON 响应）
- **Acceptance Criteria Addressed**: AC-7, AC-8
- **Test Requirements**:
  - `programmatic` TR-3.1: DioClient 构造后 dio 实例非空，baseUrl 正确
  - `programmatic` TR-3.2: ApiClient.get 成功时返回 ApiResponse<T>，isSuccess=true，data 正确
  - `programmatic` TR-3.3: ApiClient.get 在后端业务失败（HTTP 200 但 code!=200）时 isSuccess=false
  - `programmatic` TR-3.4: ApiClient.post 成功时返回正确 ApiResponse<T>
  - `programmatic` TR-3.5: ApiClient.put 成功时返回正确 ApiResponse<T>
  - `programmatic` TR-3.6: ApiClient 在 Dio 抛出网络异常时抛 ApiException（而非 DioException）
  - `programmatic` TR-3.7: ApiClient 在响应非 JSON 对象时抛 code='INVALID_RESPONSE' 的 ApiException
  - `programmatic` TR-3.8: flutter test 对应测试全部通过

## [x] Task 4: Network Providers
- **Priority**: high
- **Depends On**: Task 3
- **Description**:
  - 创建 `lib/core/network/network_providers.dart`，定义 `dioClientProvider` 和 `apiClientProvider` 两个 Riverpod Provider
  - 保留现有 `lib/core/constants/api_constants.dart` 不变（接口未定，后续再调整）
- **Acceptance Criteria Addressed**: AC-9
- **Test Requirements**:
  - `human-judgement` TR-4.1: network_providers.dart 中 Provider 定义风格与项目现有 Provider 一致（手动定义，无 @riverpod）
  - `human-judgement` TR-4.2: dioClientProvider 依赖 storageServiceProvider，拦截器顺序为 Logging → Auth → Error

## [-] Task 5: Repository 层迁移 (Auth / Home / Course)
- **Priority**: high
- **Depends On**: Task 4
- **Status**: **已跳过** — 用户明确要求接口未定，不做业务层迁移，不引入任何 API 调用。新网络模块作为纯工具类独立存在，旧 ApiService 继续供现有业务使用，待接口确定后再统一迁移。
- **Description**:
  - ~~重写 AuthRepository / HomeRepository / CourseRepository~~（跳过）
- **Acceptance Criteria Addressed**: 无

## [/] Task 6: 最终验证
- **Priority**: high
- **Depends On**: Task 4
- **Description**:
  - 保留现有 `lib/core/services/api_service.dart` 及 `api_service_provider.dart`（业务层仍在使用，待接口确定后统一迁移时删除）
  - 运行 flutter analyze 和 flutter test 全量验证，确保新增网络模块不破坏现有代码
- **Acceptance Criteria Addressed**: AC-14, AC-15
- **Test Requirements**:
  - `programmatic` TR-6.1: flutter analyze 0 errors, 0 warnings
  - `programmatic` TR-6.2: flutter test 全部通过（现有测试 + 新增网络层测试）
