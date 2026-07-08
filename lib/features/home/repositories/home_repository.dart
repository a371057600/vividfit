import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/new_main_data.dart';
import '../../../data/models/statistics_data.dart';

/// 主页网络仓库(1:1 迁移自旧 HomeController + NewMainController 的 dio 调用)。
class HomeRepository {
  HomeRepository(this._api, this._storage);

  final ApiService _api;
  final StorageService _storage;

  /// 是否走 CN 服务器(旧项目 isCnServer = box.read(languageNum) == 0)。
  bool get isCnServer => _storage.languageNum == 0;

  /// 获取运动统计(主页三环数据)。对应旧 getsportStatistics。
  Future<FitStatsData> getSportStatistics() async {
    if (_storage.userId == null) return const FitStatsData();
    final res = await _api.authedGet(
      ApiConstants.getStatisticsUrl,
      queryParameters: {
        'equipmentType': 0,
        'timeArea': 3,
        'userId': _storage.userId,
      },
    );
    return FitStatsData.fromJson(res);
  }

  /// 打卡日历检测。对应旧 getStatisticsCalendar。
  Future<bool> getStatisticsCalendar() async {
    if (_storage.userId == null) return false;
    final now = DateTime.now();
    final endDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')} 23:59:59';
    final res = await _api.authedGet(
      ApiConstants.getStatisticsCalendarUrl,
      queryParameters: {
        'startTime': '${now.year}-01-01 00:00:00',
        'userId': _storage.userId,
        'endTime': endDate,
        'duringTime': 600,
      },
    );
    if (res['code'] != '200') return false;
    final list = (res['data'] as List?) ?? [];
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final reached =
        list.any((e) => e.toString().contains(todayStr));
    await _storage.setIsReached(reached);
    return reached;
  }

  /// 整合统计数据 → FitMainData(对应旧 integratedData)。
  FitMainData integrateStatistics(FitStatsData stats, FitMainData base) {
    final totalCalorie = stats.data.fold<int>(
        0, (p, e) => p + (e.calorie));
    final totalDuring = stats.data.fold<int>(
        0, (p, e) => p + (e.duringTime));
    final todayCount = stats.data.fold<int>(
        0, (p, e) => p + (e.sportCount));
    // met = (calories * 3600) / (weight * time_in_seconds)
    final strength = (totalDuring < 600 || base.bodyWeight < 20)
        ? 0.0
        : (totalCalorie * 3600) / (totalDuring * base.bodyWeight);
    return base.copyWith(
      triCycleCalorie: totalCalorie,
      triCycleDuration: totalDuring,
      todayCount: todayCount,
      triCycleStrength: strength,
    );
  }

  /// 刷新 token。对应旧 refreshToken。
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

  /// 退出登录。对应旧 signOut。
  Future<void> signOut() async {
    try {
      await _api.authedGet(ApiConstants.signOutUrl);
    } catch (_) {}
  }
}
