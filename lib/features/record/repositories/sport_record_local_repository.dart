import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service_provider.dart';
import '../models/sport_record.dart';

part 'sport_record_local_repository.g.dart';

/// 运动记录本地存储仓库。
///
/// 基于 shared_preferences 实现，以 JSON 数组形式持久化运动记录。
/// 最多保留最近 [_maxRecords] 条（200 条），超出时自动丢弃最旧记录。
@Riverpod(keepAlive: true)
class SportRecordLocalRepository extends _$SportRecordLocalRepository {
  static const int _maxRecords = 200;

  SharedPreferences get _prefs =>
      ref.read(storageServiceProvider).prefs;

  @override
  SportRecordLocalRepository build() => this;

  // ─── 写入 ───

  /// 保存一条运动记录（追加到列表头部，按时间倒序）。
  Future<void> saveRecord(SportRecord record) async {
    final records = await _readAll();
    records.insert(0, record);
    // 超过最大数量时裁剪
    if (records.length > _maxRecords) {
      records.removeRange(_maxRecords, records.length);
    }
    await _writeAll(records);
    debugPrint('💾 [SportRecord] 已保存记录 id=${record.id}, '
        'duration=${record.duration}s, calories=${record.calories}');
  }

  // ─── 查询 ───

  /// 获取全部记录（按开始时间倒序）。
  Future<List<SportRecord>> fetchAll() async {
    return _readAll();
  }

  /// 按日期范围查询（[start] 00:00 ~ [end] 23:59）。
  Future<List<SportRecord>> fetchByDateRange(DateTime start, DateTime end) async {
    final all = await _readAll();
    return all.where((r) {
      final rStart = r.startTime;
      return !rStart.isBefore(DateTime(start.year, start.month, start.day)) &&
          !rStart.isAfter(DateTime(end.year, end.month, end.day, 23, 59, 59));
    }).toList();
  }

  /// 查询指定日期的记录。
  Future<List<SportRecord>> fetchByDate(DateTime date) async {
    return fetchByDateRange(date, date);
  }

  /// 按设备类型查询。
  Future<List<SportRecord>> fetchByDeviceType(int deviceType) async {
    final all = await _readAll();
    return all.where((r) => r.deviceType == deviceType).toList();
  }

  /// 按 ID 查询单条记录。
  Future<SportRecord?> fetchById(String id) async {
    final all = await _readAll();
    for (final r in all) {
      if (r.id == id) return r;
    }
    return null;
  }

  // ─── 聚合查询（供 Record 模块使用） ───

  /// 获取指定周的每日统计（用于 Record 主页周视图）。
  Future<List<Map<String, dynamic>>> fetchWeeklyStats(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final records = await fetchByDateRange(weekStart, weekEnd);

    final dailyStats = <Map<String, dynamic>>[];
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayRecords = records
          .where((r) =>
              r.startTime.year == day.year &&
              r.startTime.month == day.month &&
              r.startTime.day == day.day)
          .toList();

      if (dayRecords.isEmpty) {
        dailyStats.add({
          'sportCount': 0,
          'calorie': 0.0,
          'duringTime': 0,
          'sportStrength': 0.0,
          'date': day,
        });
      } else {
        double totalCalorie = 0;
        int totalDuration = 0;
        for (final r in dayRecords) {
          totalCalorie += r.calories;
          totalDuration += r.duration;
        }
        final strength = totalCalorie * 0.05 + totalDuration * 0.02;
        dailyStats.add({
          'sportCount': dayRecords.length,
          'calorie': totalCalorie,
          'duringTime': totalDuration,
          'sportStrength': strength,
          'date': day,
        });
      }
    }
    return dailyStats;
  }

  /// 获取指定日期的聚合统计。
  Future<Map<String, dynamic>?> fetchDayStats(DateTime date) async {
    final records = await fetchByDate(date);
    if (records.isEmpty) return null;

    double totalCalorie = 0;
    int totalDuration = 0;
    for (final r in records) {
      totalCalorie += r.calories;
      totalDuration += r.duration;
    }
    final strength = totalCalorie * 0.05 + totalDuration * 0.02;
    return {
      'sportCount': records.length,
      'calorie': totalCalorie,
      'duringTime': totalDuration,
      'sportStrength': strength,
    };
  }

  // ─── 删除 ───

  Future<void> deleteById(String id) async {
    final records = await _readAll();
    records.removeWhere((r) => r.id == id);
    await _writeAll(records);
  }

  Future<void> clearAll() async {
    await _prefs.remove(StorageKeys.sportRecords);
    debugPrint('🗑️ [SportRecord] 已清空全部运动记录');
  }

  // ─── 内部方法 ───

  Future<List<SportRecord>> _readAll() async {
    final jsonStr = _prefs.getString(StorageKeys.sportRecords);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
      final records = list
          .map((e) => SportRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      // 按开始时间倒序
      records.sort((a, b) => b.startTime.compareTo(a.startTime));
      return records;
    } catch (e) {
      debugPrint('❌ [SportRecord] 读取记录失败: $e');
      return [];
    }
  }

  Future<void> _writeAll(List<SportRecord> records) async {
    final list = records.map((r) => r.toJson()).toList();
    final jsonStr = jsonEncode(list);
    await _prefs.setString(StorageKeys.sportRecords, jsonStr);
  }
}
