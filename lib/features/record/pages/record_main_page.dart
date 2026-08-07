import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/them_change.dart';

/// 记录主页（空界面骨架）。
///
/// 对应旧项目 new_top_record_screen.dart。
/// 当前阶段：仅 UI 骨架 + 占位数据，无网络请求。
/// 三环、图表均显示占位（0 值 / 灰色圆环）。
class RecordMainPage extends StatefulWidget {
  const RecordMainPage({super.key});

  @override
  State<RecordMainPage> createState() => _RecordMainPageState();
}

class _RecordMainPageState extends State<RecordMainPage> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 100.r,
          backgroundColor: FitTheme.backgroundColor,
          leadingWidth: MediaQuery.of(context).size.width,
          leading: Container(
            padding: const EdgeInsets.only(left: 45).r,
            alignment: Alignment.bottomCenter,
            height: 100.r,
            child: Row(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => context.pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: FitTheme.textColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 15.w),
                Text(
                  '记录',
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontFamily: 'hofontmedium',
                    fontSize: 40.sp,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopHeaderWidget(),
              _buildThreeRingPlaceholder(),
              _buildRecordListButton(),
              _buildChartPlaceholder('时长', const Color(0xFFFFA200)),
              _buildChartPlaceholder('强度', const Color(0xFF2C80FD)),
              _buildChartPlaceholder('消耗', const Color(0xFFFF4D4F)),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  /// 顶部周日历区域（占位，仅展示当前周）。
  Widget _buildTopHeaderWidget() {
    return Container(
      height: 300.h,
      margin: const EdgeInsets.symmetric(horizontal: 25).r,
      child: TableCalendar(
        weekendDays: const [DateTime.saturday, DateTime.sunday],
        startingDayOfWeek: StartingDayOfWeek.monday,
        rowHeight: 100.h,
        daysOfWeekHeight: 50.h,
        headerVisible: true,
        daysOfWeekVisible: true,
        shouldFillViewport: true,
        firstDay: DateTime.utc(2019, 1, 1),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.week,
        onFormatChanged: (format) {},
        onDaySelected: (selectedDay, focusedDay) {
          setState(() => _focusedDay = focusedDay);
        },
        selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            color: FitTheme.textColor,
            fontSize: 30.sp,
          ),
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronPadding: const EdgeInsets.only(left: 15).r,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: const Color(0xFF515151),
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: const Color(0xFF515151),
          ),
          headerPadding: EdgeInsets.zero,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
          weekendStyle: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
        ),
        calendarStyle: const CalendarStyle(),
      ),
    );
  }

  /// 三环占位区域。
  /// 当前阶段：无数据，三环显示灰色圆环 + 0 值文本。
  Widget _buildThreeRingPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 65, vertical: 15).r,
      height: 390.h,
      width: 700.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 380.r,
            height: 380.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 380.r,
                  height: 380.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF333333),
                    border: Border.all(
                      color: FitTheme.textColor.withValues(alpha: 0.3),
                      width: 35.r,
                    ),
                  ),
                ),
                Container(
                  width: 300.r,
                  height: 300.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF444444),
                    border: Border.all(
                      color: FitTheme.textColor.withValues(alpha: 0.3),
                      width: 35.r,
                    ),
                  ),
                ),
                Container(
                  width: 220.r,
                  height: 220.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF555555),
                    border: Border.all(
                      color: FitTheme.textColor.withValues(alpha: 0.3),
                      width: 35.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 40.w),
          Container(
            width: 150.w,
            height: 380.h,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSideText('时长/分钟', '00:00:00'),
                _buildSideText('MET', '0.0'),
                _buildSideText('卡路里', '0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideText(String title, String value) {
    return SizedBox(
      width: 150.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              title,
              style: TextStyle(
                letterSpacing: 0.5,
                color: FitTheme.textColor,
                fontSize: 25.sp,
                fontFamily: 'hofontmedium',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 2).r,
            width: 120.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: FitTheme.buttonColor,
              borderRadius: BorderRadius.circular(5).r,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 35.sp,
              height: 1,
              color: FitTheme.textColor,
              fontFamily: 'BEBAS',
            ),
          ),
        ],
      ),
    );
  }

  /// "运动记录"按钮，跳转到列表页。
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
          borderRadius: BorderRadius.circular(20).r,
          color: FitTheme.buttonColor,
        ),
        child: Text(
          '运动记录',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 单个指标图表占位卡。
  Widget _buildChartPlaceholder(String title, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25).r,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 40.r,
                    width: 40.r,
                    child: Icon(
                      Icons.bar_chart,
                      color: FitTheme.textColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 30.sp,
                      height: 1.25,
                      color: FitTheme.textColor,
                    ),
                  ),
                ],
              ),
              Text(
                '0',
                style: TextStyle(
                  fontSize: 35.sp,
                  color: FitTheme.textColor,
                  fontFamily: 'BEBAS',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(
                Icons.bar_chart,
                color: color.withValues(alpha: 0.5),
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
