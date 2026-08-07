import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/network/network_providers.dart';
import '../data/course_play_data.dart';

part 'course_detail_repository.g.dart';

/// 课程详情仓库(复用现有 `dioClientProvider`,直接 GET 公开 JSON)。
///
/// 1:1 迁移自旧 `ControllerCourseDetail.getData()` 的 URL 切换逻辑。
/// URL 按 `FtmsDeviceType` 切换,跑步机特殊处理葡萄牙语(languageNum==5)。
///
/// 本阶段仅实现 `fetchCoursePlayData`(GET JSON);
/// 下载/解压方法(downloadFile/unzipFile)留待后续下载任务测试后补充。
class CourseDetailRepository {
  CourseDetailRepository(this._dio);

  final Dio _dio;

  /// 按设备类型获取课程播放数据 JSON。
  ///
  /// [languageNum] 用于跑步机葡萄牙语判断(5=葡语)。
  Future<CoursePlayData> fetchCoursePlayData({
    required FtmsDeviceType deviceType,
    required int languageNum,
  }) async {
    final url = _resolveUrl(deviceType, languageNum);
    final response = await _dio.get<dynamic>(url);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'CoursePlayData response is not a JSON object: ${data.runtimeType}',
      );
    }
    return CoursePlayData.fromJson(data);
  }

  /// URL 映射表(1:1 还原旧 `getData` 的 switch case)。
  String _resolveUrl(FtmsDeviceType type, int languageNum) {
    const base = 'https://gamifits.fitmonster.club/training';
    return switch (type) {
      FtmsDeviceType.indoorBike => '$base/coursePlayDataBike.json',
      FtmsDeviceType.treadmill =>
        languageNum == 5 ? '$base/coursePlayDataRunPt.json' : '$base/coursePlayDataRun.json',
      FtmsDeviceType.crossTrainer => '$base/coursePlayDataElliptical.json',
      FtmsDeviceType.rower => '$base/coursePlayDataRowing.json',
      FtmsDeviceType.strengthStation => '$base/coursePlayData.json',
    };
  }
}

/// Repository Provider(Riverpod 3.0 代码生成,keepAlive)。
/// 复用现有 `dioClientProvider`,不新建 Dio 实例。
@Riverpod(keepAlive: true)
CourseDetailRepository courseDetailRepository(Ref ref) {
  return CourseDetailRepository(ref.watch(dioClientProvider).dio);
}
