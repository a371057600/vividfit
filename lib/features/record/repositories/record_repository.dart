import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/network/sport_history.dart';
import '../models/record_equipment_type.dart';
import '../models/record_stats_item.dart';
import 'sport_record_local_repository.dart';

part 'record_repository.g.dart';

/// FtmsDeviceType.value → RecordEquipmentType.id 映射
int _mapDeviceType(int ftmsDeviceTypeValue) {
  switch (ftmsDeviceTypeValue) {
    case 0: // indoorBike
      return 1; // spinBike
    case 1: // treadmill
      return 2; // treadmill
    case 2: // crossTrainer
      return 3; // elliptical
    case 3: // rower
      return 4; // rowingMachine
    default:
      return 0;
  }
}

String _formatDate(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

String _formatDateTime(DateTime dt) {
  return '${_formatDate(dt)} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
}

@Riverpod(keepAlive: true)
class RecordRepository extends _$RecordRepository {
  @override
  RecordRepository build() => this;

  /// 获取本周每日运动统计（周一至周日）
  Future<RecordStatsResponse> fetchWeekStats() async {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));

    final weekData = <RecordStatsItem>[];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dateStr = _formatDate(date);

      final records = await ref
          .read(sportRecordLocalRepositoryProvider)
          .fetchByDate(date);

      if (records.isEmpty) {
        weekData.add(RecordStatsItem(
          sportCount: 0,
          calorie: 0.0,
          duringTime: 0,
          sportStrength: 0.0,
          startTime: '$dateStr 00:00:00',
          endTime: '$dateStr 23:59:59',
        ));
        continue;
      }

      final totalCalorie = records.fold<double>(
          0.0, (sum, r) => sum + r.calories);
      final totalDuration = records.fold<int>(
          0, (sum, r) => sum + r.duration);
      final totalDistance = records.fold<double>(
          0.0, (sum, r) => sum + r.distance);
      final strength = totalDuration > 0
          ? double.parse((totalDistance / totalDuration * 60).toStringAsFixed(1))
          : 0.0;

      weekData.add(RecordStatsItem(
        sportCount: records.length,
        calorie: totalCalorie,
        duringTime: totalDuration,
        sportStrength: strength,
        startTime: '$dateStr 00:00:00',
        endTime: '$dateStr 23:59:59',
      ));
    }

    return RecordStatsResponse(code: '200', data: weekData);
  }

  /// 获取指定日期的运动统计汇总
  Future<RecordStatsItem?> fetchDayStats(DateTime date) async {
    final records = await ref
        .read(sportRecordLocalRepositoryProvider)
        .fetchByDate(date);

    if (records.isEmpty) return null;

    final dateStr = _formatDate(date);
    final totalCalorie =
        records.fold<double>(0.0, (sum, r) => sum + r.calories);
    final totalDuration =
        records.fold<int>(0, (sum, r) => sum + r.duration);
    final totalDistance =
        records.fold<double>(0.0, (sum, r) => sum + r.distance);
    final strength = totalDuration > 0
        ? double.parse((totalDistance / totalDuration * 60).toStringAsFixed(1))
        : 0.0;

    return RecordStatsItem(
      sportCount: records.length,
      calorie: totalCalorie,
      duringTime: totalDuration,
      sportStrength: strength,
      startTime: '$dateStr 00:00:00',
      endTime: '$dateStr 23:59:59',
    );
  }

  /// 获取运动历史列表（支持年份 + 设备类型筛选）
  Future<List<SportHistory>> fetchHistory({
    required int year,
    RecordEquipmentType equipmentType = RecordEquipmentType.all,
  }) async {
    final allRecords = await ref
        .read(sportRecordLocalRepositoryProvider)
        .fetchAll();

    final records = allRecords.where((r) {
      if (r.endTime.year != year) return false;
      if (equipmentType != RecordEquipmentType.all) {
        final mapped = _mapDeviceType(r.deviceType);
        if (mapped != equipmentType.id) return false;
      }
      return true;
    }).toList();

    records.sort((a, b) => b.endTime.compareTo(a.endTime));

    return records.map((r) {
      return SportHistory(
        id: int.tryParse(r.id.split('_').first) ?? 0,
        userId: r.userId,
        equipmentType: _mapDeviceType(r.deviceType),
        mode: r.mode,
        trainMode: r.trainMode,
        calories: r.calories,
        duringTime: r.duration,
        distance: r.distance,
        count: r.totalStrokes,
        isOffline: false,
        startTime: _formatDateTime(r.startTime),
        createTime: _formatDateTime(r.endTime),
      );
    }).toList();
  }
}
