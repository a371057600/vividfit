import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/course_list.dart';
import '../../../data/models/course_detail.dart';

/// 课程模块网络仓库。
///
/// 当前为占位实现：所有网络请求返回假数据，保证 UI 可独立运行。
/// 后续接入真实接口时，只需替换 body 中的假数据逻辑。
class CourseRepository {
  CourseRepository(this._api, this._storage);

  final ApiService _api;
  final StorageService _storage;

  bool get isCnServer => _storage.languageNum == 0;

  // TODO: 接入真实接口后使用
  // ignore: unused_element
  int get _langNumber {
    final lang = _storage.languageNum;
    return lang > 3 ? 1 : lang;
  }

  /// 获取课程列表（占位）。
  Future<CourseList> getCourseList(List<int> tags) async {
    // TODO: 接入真实接口时取消注释下方代码
    // final res = await _api.post(
    //   ApiConstants.getCourseListUrl,
    //   data: <String, Object>{
    //     'language': _langNumber,
    //     'page': 0,
    //     'pageLimited': 50,
    //     'tags': tags,
    //   },
    // );
    // return CourseList.fromJson(res);

    // 假数据占位
    return CourseList(
      code: '200',
      data: CourseListData(
        dataList: List.generate(
          6,
          (index) => CourseItem(
            id: index + 1,
            title: 'Course ${index + 1}',
            cover: '',
            describe: 'Course description placeholder',
            proposal: 'Course proposal placeholder',
            carefulthing: 'Be careful',
            during: 600,
            level: 1,
            interactiveEquipment: 1,
            version: 1,
            courseBgm: 'null',
          ),
        ),
      ),
    );
  }

  /// 获取课程动作详情（占位）。
  Future<CourseDetail> getCourseDetail(String courseId) async {
    // TODO: 接入真实接口时取消注释下方代码
    // final res = await _api.get(
    //   ApiConstants.getCourseActionUrl,
    //   queryParameters: <String, Object>{
    //     'language': _storage.languageNum,
    //     'courseId': courseId,
    //   },
    // );
    // return CourseDetail.fromJson(res);

    // 假数据占位
    return CourseDetail(
      code: '200',
      data: List.generate(
        5,
        (index) => CourseAction(
          actionId: index,
          actionType: index == 0 ? -1 : 0,
          actionName: 'Action ${index + 1}',
          actionIntroduce: 'Action introduction placeholder',
          during: 30,
          speed: 30,
          picturesList: ActionPictures(
            actionPictureName: 'action$index.zip',
            actionPictureHash: '',
          ),
        ),
      ),
    );
  }

  /// 刷新 token（复用现有逻辑）。
  Future<bool> refreshToken() async {
    if (_storage.accessToken == null) return false;
    try {
      final res = await _api.authedGet(ApiConstants.refreshTokenUrl);
      if (res['code'].toString() == '200') {
        await _storage.setAccessToken(res['data'].toString());
        await _storage.setTokenDateTime(DateTime.now().toString());
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
