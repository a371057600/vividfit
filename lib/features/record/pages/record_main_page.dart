import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/app_fonts.dart';
import '../../../core/constants/them_change.dart';
import '../models/record_stats_item.dart';
import '../notifiers/record_main_notifier.dart';
import '../states/record_main_state.dart';
import '../widgets/mini_day_rings.dart';
import '../widgets/record_chart_card.dart';
import '../widgets/record_three_rings.dart';

/// 记录主页（三环进度 + 图表数据展示）。
///
/// 对应旧项目 new_top_record_screen.dart。
/// 当前阶段：Mock 数据驱动，所有展示数据来自 RecordMainNotifier。
class RecordMainPage extends ConsumerStatefulWidget {
  const RecordMainPage({super.key});

  @override
  ConsumerState<RecordMainPage> createState() => _RecordMainPageState();
}

class _RecordMainPageState extends ConsumerState<RecordMainPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordMainProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 100.r,
          backgroundColor: FitTheme.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => context.pop(),
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10).r,
              child: Icon(
                Icons.arrow_back_ios,
                color: FitTheme.textColor,
                size: 22,
              ),
            ),
          ),
          leadingWidth: 80.w,
          title: Text(
            '运动记录',
            style: TextStyle(
              color: FitTheme.textColor,
              fontFamily: AppFonts.hofontmedium,
              fontSize: 36.sp,
            ),
          ),
          centerTitle: false,
        ),
        body: state.isLoading
            ? Center(
                child: CircularProgressIndicator(color: FitTheme.buttonColor),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    _buildCalendar(state),
                    SizedBox(height: 5.h),
                    _buildThreeRingSection(state),
                    _buildRecordListButton(),
                    _buildChartCards(state),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCalendar(RecordMainState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15).r,
      height: 220.h,
      child: TableCalendar(
        locale: 'zh_CN',
        weekendDays: const [DateTime.saturday, DateTime.sunday],
        startingDayOfWeek: StartingDayOfWeek.monday,
        rowHeight: 80.h,
        daysOfWeekHeight: 28.h,
        headerVisible: true,
        daysOfWeekVisible: true,
        shouldFillViewport: false,
        firstDay: DateTime.utc(2019, 1, 1),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        calendarFormat: CalendarFormat.week,
        availableCalendarFormats: const {CalendarFormat.week: ''},
        onFormatChanged: (_) {},
        onPageChanged: (focusedDay) {
          setState(() => _focusedDay = focusedDay);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          ref.read(recordMainProvider.notifier).selectDay(selectedDay);
        },
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextFormatter: (date, _) => '${date.year}年${date.month}月',
          titleTextStyle: TextStyle(
            color: FitTheme.textColor,
            fontSize: 28.sp,
            fontFamily: AppFonts.hofontmedium,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.grey,
            size: 24,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 24,
          ),
          headerPadding: EdgeInsets.zero,
          headerMargin: EdgeInsets.zero,
          leftChevronPadding: const EdgeInsets.symmetric(horizontal: 16).r,
          rightChevronPadding: const EdgeInsets.symmetric(horizontal: 16).r,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 20.sp, color: FitTheme.textColor),
          weekendStyle: TextStyle(fontSize: 20.sp, color: FitTheme.textColor),
          dowTextFormatter: (date, _) {
            const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
            return weekdays[date.weekday - 1];
          },
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) =>
              _buildDayCell(day, state, isSelected: false),
          todayBuilder: (context, day, focusedDay) =>
              _buildDayCell(day, state, isSelected: false, isToday: true),
          selectedBuilder: (context, day, focusedDay) =>
              _buildDayCell(day, state, isSelected: true),
          outsideBuilder: (context, day, focusedDay) =>
              _buildDayCell(day, state, isSelected: false, isOutside: true),
        ),
      ),
    );
  }

  Widget _buildDayCell(
    DateTime day,
    RecordMainState state, {
    required bool isSelected,
    bool isToday = false,
    bool isOutside = false,
  }) {
    final weekIndex = day.weekday - 1;
    RecordStatsItem? dayStats;
    if (weekIndex >= 0 && weekIndex < state.weekStats.length) {
      final stats = state.weekStats[weekIndex];
      final statsDate = stats.startTime?.substring(0, 10);
      final dayStr =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      if (statsDate == dayStr) {
        dayStats = stats;
      }
    }

    double dProg = 0, sProg = 0, cProg = 0;
    if (dayStats != null) {
      dProg = state.goalDuration > 0
          ? ((dayStats.duringTime ~/ 60) / state.goalDuration).clamp(0.0, 1.0)
          : 0.0;
      sProg = state.goalStrength > 0
          ? (dayStats.sportStrength / state.goalStrength).clamp(0.0, 1.0)
          : 0.0;
      cProg = state.goalCalorie > 0
          ? (dayStats.calorie / state.goalCalorie).clamp(0.0, 1.0)
          : 0.0;
    }

    return Container(
      width: 65.r,
      height: 150.h,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              color: isOutside
                  ? FitTheme.textColor.withValues(alpha: 0.3)
                  : FitTheme.textColor,
              fontSize: 24.sp,
              fontFamily: AppFonts.bebas,
            ),
          ),
          SizedBox(height: 10.h),
          MiniDayRings(
            durationProgress: dProg,
            strengthProgress: sProg,
            calorieProgress: cProg,
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildThreeRingSection(RecordMainState state) {
    final stats = state.selectedDayStats;
    final durationSec = stats?.duringTime ?? 0;
    final hours = (durationSec ~/ 3600).toString().padLeft(2, '0');
    final mins = ((durationSec % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (durationSec % 60).toString().padLeft(2, '0');

    final dProg = state.goalDuration > 0
        ? ((durationSec ~/ 60) / state.goalDuration).clamp(0.0, 1.0)
        : 0.0;
    final sProg = state.goalStrength > 0
        ? ((stats?.sportStrength ?? 0) / state.goalStrength).clamp(0.0, 1.0)
        : 0.0;
    final cProg = state.goalCalorie > 0
        ? ((stats?.calorie ?? 0) / state.goalCalorie).clamp(0.0, 1.0)
        : 0.0;

    return RecordThreeRings(
      durationProgress: dProg.toDouble(),
      strengthProgress: sProg.toDouble(),
      calorieProgress: cProg.toDouble(),
      durationText: '$hours:$mins:$secs',
      strengthText: (stats?.sportStrength ?? 0).toStringAsFixed(0),
      calorieText: (stats?.calorie ?? 0).toStringAsFixed(0),
    );
  }

  Widget _buildRecordListButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.push('/record-list'),
      child: Container(
        height: 80.h,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5).r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: FitTheme.buttonColor,
        ),
        child: Text(
          '运动记录',
          style: TextStyle(
            color: FitTheme.textButtonColor,
            fontSize: 30.sp,
            fontFamily: AppFonts.hofontmedium,
          ),
        ),
      ),
    );
  }

  Widget _buildChartCards(RecordMainState state) {
    final stats = state.selectedDayStats;
    final durationMin = stats != null ? (stats.duringTime ~/ 60) : 0;
    final met = stats?.sportStrength ?? 0.0;
    final calorie = stats?.calorie ?? 0.0;

    final dPct = state.goalDuration > 0
        ? (durationMin / state.goalDuration * 100).toStringAsFixed(0)
        : '0';
    final sPct = state.goalStrength > 0
        ? (met / state.goalStrength * 100).toStringAsFixed(0)
        : '0';
    final cPct = state.goalCalorie > 0
        ? (calorie / state.goalCalorie * 100).toStringAsFixed(0)
        : '0';

    final weekDuration = state.weekStats
        .map((e) => (e.duringTime / 60).toDouble())
        .toList();
    final weekStrength = state.weekStats
        .map((e) => e.sportStrength.toDouble())
        .toList();
    final weekCalorie = state.weekStats
        .map((e) => e.calorie.toDouble())
        .toList();

    return Column(
      children: [
        RecordChartCard(
          icon: Icons.access_time,
          title: '时长/ MIN',
          currentValue: durationMin.toStringAsFixed(1),
          completionPercent: '$dPct%',
          goalValue: '${state.goalDuration}',
          accentColor: FitTheme.threeRingsColorOutSide,
          weekValues: weekDuration,
          maxY: state.goalDuration.toDouble(),
        ),
        RecordChartCard(
          icon: Icons.directions_run,
          title: '运动强度/MET',
          currentValue: met.toStringAsFixed(0),
          completionPercent: '$sPct%',
          goalValue: state.goalStrength.toStringAsFixed(1),
          accentColor: FitTheme.threeRingsColorMiddle,
          weekValues: weekStrength,
          maxY: state.goalStrength,
        ),
        RecordChartCard(
          icon: Icons.local_fire_department,
          title: '消耗热量/K',
          currentValue: calorie.toStringAsFixed(0),
          completionPercent: '$cPct%',
          goalValue: '${state.goalCalorie.toInt()}',
          accentColor: FitTheme.threeRingsColorInSide,
          weekValues: weekCalorie,
          maxY: state.goalCalorie,
        ),
      ],
    );
  }
}
