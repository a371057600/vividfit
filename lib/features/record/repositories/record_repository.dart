import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/network/sport_history.dart';
import '../models/record_equipment_type.dart';
import '../models/record_stats_item.dart';

part 'record_repository.g.dart';

@Riverpod(keepAlive: true)
class RecordRepository extends _$RecordRepository {
  @override
  RecordRepository build() => this;

  Future<RecordStatsResponse> fetchWeekStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final List<RecordStatsItem> weekData = [];

    final mockData = [
      (3, 180.5, 1200, 4.2),
      (5, 320.0, 1800, 6.5),
      (2, 150.0, 900, 3.1),
      (4, 250.0, 1500, 5.0),
      (6, 400.0, 2100, 7.2),
      (8, 550.0, 2700, 8.8),
      (1, 80.0, 600, 2.0),
    ];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final d = mockData[i];
      weekData.add(RecordStatsItem(
        sportCount: d.$1,
        calorie: d.$2,
        duringTime: d.$3,
        sportStrength: d.$4,
        startTime: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} 00:00:00',
        endTime: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} 23:59:59',
      ));
    }

    return RecordStatsResponse(code: '200', data: weekData);
  }

  Future<RecordStatsItem?> fetchDayStats(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = date.weekday - 1;
    final mockData = [
      (3, 180.5, 1200, 4.2),
      (5, 320.0, 1800, 6.5),
      (2, 150.0, 900, 3.1),
      (4, 250.0, 1500, 5.0),
      (6, 400.0, 2100, 7.2),
      (8, 550.0, 2700, 8.8),
      (1, 80.0, 600, 2.0),
    ];
    if (index >= 0 && index < 7) {
      final d = mockData[index];
      return RecordStatsItem(
        sportCount: d.$1,
        calorie: d.$2,
        duringTime: d.$3,
        sportStrength: d.$4,
        startTime: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} 00:00:00',
        endTime: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} 23:59:59',
      );
    }
    return null;
  }

  Future<List<SportHistory>> fetchHistory({
    required int year,
    RecordEquipmentType equipmentType = RecordEquipmentType.all,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final records = <SportHistory>[];
    final now = DateTime.now();

    final deviceTypes = [
      RecordEquipmentType.spinBike,
      RecordEquipmentType.treadmill,
      RecordEquipmentType.elliptical,
      RecordEquipmentType.rowingMachine,
    ];

    final mockRecords = [
      (3, 5, 1500, 180.5, 3, 1, 0),
      (3, 12, 2100, 280.0, 5, 1, 2),
      (3, 20, 900, 120.0, 2, 0, 1),
      (3, 28, 1800, 240.0, 4, 2, 3),
      (5, 8, 1200, 160.0, 3, 1, 0),
      (5, 15, 2400, 320.0, 6, 1, 2),
      (5, 22, 1500, 200.0, 4, 2, 1),
      (7, 3, 2700, 360.0, 7, 1, 3),
      (7, 10, 1800, 240.0, 5, 1, 0),
      (7, 17, 2100, 280.0, 6, 2, 2),
      (7, 24, 1500, 200.0, 4, 0, 1),
      (7, 31, 900, 120.0, 2, 1, 3),
      (8, 5, 3000, 400.0, 8, 1, 2),
      (8, 8, 1200, 160.0, 3, 1, 0),
      (8, 12, 2400, 320.0, 6, 2, 3),
      (8, 15, 1800, 240.0, 5, 0, 1),
      (8, 18, 1500, 200.0, 4, 1, 2),
      (8, 21, 2100, 280.0, 5, 1, 0),
    ];

    int idCounter = 1;
    for (final m in mockRecords) {
      final month = m.$1;
      final day = m.$2;
      final duringTime = m.$3;
      final calories = m.$4;
      final count = m.$5;
      final mode = m.$6;
      final trainMode = m.$7;

      if (year != now.year) continue;

      final deviceIndex = idCounter % deviceTypes.length;
      final deviceType = deviceTypes[deviceIndex];

      if (equipmentType != RecordEquipmentType.all && equipmentType != deviceType) {
        idCounter++;
        continue;
      }

      records.add(SportHistory(
        id: idCounter,
        userId: 1,
        equipmentType: deviceType.id,
        mode: mode,
        trainMode: trainMode,
        calories: calories,
        duringTime: duringTime,
        distance: 0.0,
        count: count,
        isOffline: false,
        startTime: '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${8 + (idCounter % 12)}:${(idCounter * 7) % 60}:00',
        createTime: '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${8 + (idCounter % 12)}:${(idCounter * 7) % 60}:00',
      ));
      idCounter++;
    }

    records.sort((a, b) => (b.startTime ?? '').compareTo(a.startTime ?? ''));
    return records;
  }
}