import 'api_exception.dart';
import 'api_response.dart';

extension ApiResponseX<T> on ApiResponse<T> {
  T getOrThrow() {
    if (!isSuccess) {
      throw ApiException(
        code: code,
        message: message ?? 'Request failed with code $code',
      );
    }
    if (data == null) {
      throw ApiException(
        code: code,
        message: 'Response data is null',
      );
    }
    return data!;
  }
}
