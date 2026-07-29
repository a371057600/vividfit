import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ftms/ftms_device_type.dart';
import '../../../core/network/network_providers.dart';
import '../data/course_catalog.dart';

part 'course_catalog_repository.g.dart';

/// 课程目录仓库(复用现有 `dioClientProvider`,直接 GET 公开 JSON)。
///
/// 1:1 迁移自旧 `BigCourseHomeController.getNewCourseList()` 的 URL 切换逻辑。
/// URL 按 `FtmsDeviceType` 切换,跑步机特殊处理葡萄牙语(languageNum==5)。
class CourseCatalogRepository {
  CourseCatalogRepository(this._dio);

  final Dio _dio;

  /// 按设备类型获取课程目录 JSON。
  ///
  /// [languageNum] 用于跑步机葡萄牙语判断(5=葡语)。
  Future<CourseCatalog> fetchCatalog({
    required FtmsDeviceType deviceType,
    required int languageNum,
  }) async {
    final url = _resolveUrl(deviceType, languageNum);
    final response = await _dio.get<dynamic>(url);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Course catalog response is not a JSON object: ${data.runtimeType}',
      );
    }
    return CourseCatalog.fromJson(data);
  }

  /// URL 映射表(1:1 还原旧 `getNewCourseList` 的 switch case)。
  String _resolveUrl(FtmsDeviceType type, int languageNum) {
    const base = 'https://gamifits.fitmonster.club/training';
    return switch (type) {
      FtmsDeviceType.indoorBike => '$base/courseTypeListBike.json',
      FtmsDeviceType.treadmill =>
        languageNum == 5 ? '$base/courseTypeListRunPt.json' : '$base/courseTypeListRun.json',
      FtmsDeviceType.crossTrainer => '$base/courseTypeListElliptical.json',
      FtmsDeviceType.rower => '$base/courseTypeListRowing.json',
      FtmsDeviceType.strengthStation => '$base/courseTypeList.json',
    };
  }
}

/// Repository Provider(Riverpod 3.0 代码生成,keepAlive)。
/// 复用现有 `dioClientProvider`,不新建 Dio 实例。
@Riverpod(keepAlive: true)
CourseCatalogRepository courseCatalogRepository(Ref ref) {
  return CourseCatalogRepository(ref.watch(dioClientProvider).dio);
}
