import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';

import '../../../core/constants/them_change.dart';
import '../../../data/models/network/sport_history.dart';
import '../models/record_equipment_type.dart';
import '../notifiers/record_list_notifier.dart';
import '../states/record_list_state.dart';
import 'widgets/empty_data_widget.dart';

/// 记录列表页（年度运动总览 + 历史记录列表）。
///
/// 对应旧项目 new_record_list_screen.dart。
/// 当前阶段：Mock 数据驱动，所有展示数据来自 RecordListNotifier。
class RecordListPage extends ConsumerStatefulWidget {
  const RecordListPage({super.key});

  @override
  ConsumerState<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends ConsumerState<RecordListPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordListProvider);
    final notifier = ref.read(recordListProvider.notifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 100.h,
          scrolledUnderElevation: 0,
          backgroundColor: FitTheme.backgroundColor,
          leadingWidth: MediaQuery.of(context).size.width,
          actions: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => _showEquipmentSelector(state, notifier),
              child: Container(
                alignment: Alignment.bottomRight,
                height: MediaQuery.of(context).size.height * 0.12,
                width: 250.r,
                margin: const EdgeInsets.only(right: 45, bottom: 20).r,
                child: Text(
                  state.equipmentType.displayName,
                  maxLines: 1,
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 25.sp,
                    fontFamily: 'hofontmedium',
                  ),
                ),
              ),
            ),
          ],
          leading: Container(
            padding: const EdgeInsets.only(left: 45).r,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => context.pop(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 10).r,
                    height: 100.r,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: FitTheme.textColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    '运动记录列表',
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontFamily: 'hofontmedium',
                      fontSize: 40.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildMainBody(state, notifier),
      ),
    );
  }

  Widget _buildMainBody(RecordListState state, RecordListNotifier notifier) {
    return Container(
      color: FitTheme.backgroundColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: state.historyList.isEmpty
          ? ListView(
              children: [
                _buildHeaderWidget(state, notifier),
                EmptyDataWidget(
                  message: '暂无运动记录',
                  iconPath: 'images/newUIScreen/icons/icon_noInetrnet.png',
                ),
              ],
            )
          : ListView(
              children: [
                _buildHeaderWidget(state, notifier),
                _buildRecordList(state, notifier),
              ],
            ),
    );
  }

  Widget _buildHeaderWidget(RecordListState state, RecordListNotifier notifier) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildYearSelector(state, notifier),
          SizedBox(height: 20.h),
          _buildHeaderDataRow(state),
        ],
      ),
    );
  }

  Widget _buildYearSelector(RecordListState state, RecordListNotifier notifier) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20).r,
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: state.year > 2021
                ? () => notifier.changeYear(state.year - 1)
                : null,
            child: Icon(Icons.arrow_back_ios, size: 40.sp),
          ),
          Text(
            '${state.year} 年度总览',
            style: TextStyle(
              color: FitTheme.textColor,
              fontFamily: 'hofontmedium',
              fontSize: 25.sp,
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: state.year < DateTime.now().year
                ? () => notifier.changeYear(state.year + 1)
                : null,
            child: Icon(Icons.arrow_forward_ios_sharp, size: 40.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDataRow(RecordListState state) {
    final totalDurationHours = state.totalDuration ~/ 3600;
    final totalDurationMins = (state.totalDuration % 3600) ~/ 60;
    final durationText = totalDurationHours > 0
        ? '${totalDurationHours}h ${totalDurationMins}m'
        : '${totalDurationMins}m';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeaderDataWidget(
            '${state.totalCount}',
            '总运动次数',
            Alignment.centerLeft,
        ),
        _buildHeaderDataWidget(durationText, '总时长', Alignment.center),
        _buildHeaderDataWidget(
            state.totalCalorie.toStringAsFixed(0),
            '总消耗(kcal)',
            Alignment.centerRight,
        ),
      ],
    );
  }

  Widget _buildHeaderDataWidget(
      String value, String title, Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20).r,
      width: 220.w,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'BEBAS',
              fontSize: 40.sp,
              color: FitTheme.textColor,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(fontSize: 25.sp, color: FitTheme.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordList(RecordListState state, RecordListNotifier notifier) {
    final groupedData = state.groupedData;
    final sortedMonths = groupedData.keys.toList()..sort((int a, int b) => b.compareTo(a));

    return Column(
      children: sortedMonths.map((month) {
        final records = groupedData[month]!;
        return _buildMonthSection(month, records);
      }).toList(),
    );
  }

  Widget _buildMonthSection(int month, List<SportHistory> records) {
    final monthNames = [
      '', '一月', '二月', '三月', '四月', '五月', '六月',
      '七月', '八月', '九月', '十月', '十一月', '十二月',
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10).r,
            child: Text(
              monthNames[month],
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 30.sp,
                fontFamily: 'hofontmedium',
              ),
            ),
          ),
          ...records.map((r) => _buildRecordItem(r)),
        ],
      ),
    );
  }

  Widget _buildRecordItem(SportHistory record) {
    final startTime = record.startTime ?? '';
    final deviceType = RecordEquipmentType.fromId(record.equipmentType ?? 0);
    final durationMin = (record.duringTime ?? 0) ~/ 60;
    final durationSec = (record.duringTime ?? 0) % 60;
    final calories = record.calories ?? 0.0;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        context.push('/record-detail', extra: {
          'equipmentType': deviceType,
          'record': record,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15).r,
        padding: const EdgeInsets.all(20).r,
        decoration: BoxDecoration(
          color: FitTheme.secondbackGround,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: FitTheme.buttonColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                deviceType.icon,
                color: FitTheme.buttonColor,
                size: 40,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deviceType.displayName,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 28.sp,
                      fontFamily: 'hofontmedium',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    startTime.isNotEmpty
                        ? startTime.substring(0, 16).replaceAll('T', ' ')
                        : '',
                    style: TextStyle(
                      color: FitTheme.textColor.withValues(alpha: 0.6),
                      fontSize: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${durationMin.toString().padLeft(2, '0')}:${durationSec.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: FitTheme.textColor,
                    fontSize: 30.sp,
                    fontFamily: 'BEBAS',
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  '${calories.toStringAsFixed(0)} kcal',
                  style: TextStyle(
                    color: FitTheme.buttonColor,
                    fontSize: 22.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEquipmentSelector(RecordListState state, RecordListNotifier notifier) {
    int tempIndex = RecordEquipmentType.values.indexOf(state.equipmentType);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: FitTheme.secondbackGround,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 25.h),
              Text(
                '设备选择',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: FitTheme.textColor,
                  fontFamily: 'hofontmedium',
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25).r,
                child: GroupButton<String>(
                buttons: RecordEquipmentType.values
                    .map((e) => e.displayName)
                    .toList(),
                onSelected: (value, index, isSelected) {
                    setSheetState(() => tempIndex = index);
                  },
                  options: GroupButtonOptions(
                    mainGroupAlignment: MainGroupAlignment.spaceBetween,
                    unselectedShadow: [],
                    spacing: 50.r,
                    runSpacing: 30.r,
                    elevation: 0,
                    borderRadius: BorderRadius.circular(20),
                    selectedColor: FitTheme.threebackGround,
                    unselectedColor: FitTheme.threebackGround,
                    unselectedTextStyle: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 18.sp,
                      fontFamily: 'hofontmedium',
                    ),
                    selectedTextStyle: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 18.sp,
                      fontFamily: 'hofontmedium',
                    ),
                    selectedBorderColor: Colors.blue,
                    buttonHeight: 30,
                    buttonWidth: 200.r,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  final selectedType = RecordEquipmentType.values[tempIndex];
                  notifier.changeEquipmentType(selectedType);
                  Navigator.of(sheetContext).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 80.h,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30).r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: FitTheme.buttonColor,
                  ),
                  child: Text(
                    '确认',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}