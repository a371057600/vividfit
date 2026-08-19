import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../../../data/models/network/sport_history.dart';
import '../models/record_equipment_type.dart';
import '../notifiers/record_detail_notifier.dart';

/// 记录详情页（单次运动数据详情 + 上一次记录对比）。
///
/// 对应旧项目 new_record_interface_second_level_screen.dart。
/// 数据来自路由参数 + RecordDetailNotifier（真实数据源）。
class RecordDetailPage extends ConsumerStatefulWidget {
  final RecordEquipmentType equipmentType;
  final SportHistory? record;

  const RecordDetailPage({
    super.key,
    this.equipmentType = RecordEquipmentType.all,
    this.record,
  });

  @override
  ConsumerState<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends ConsumerState<RecordDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.record != null) {
        ref.read(recordDetailProvider.notifier).loadDetail(widget.record!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordDetailProvider);
    final current = state.currentRecord;
    final previous = state.previousRecord;

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColor,
        appBar: AppBar(
          leadingWidth: 750.w,
          leading: Container(
            margin: const EdgeInsets.only(left: 45).r,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => context.pop(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(right: 10.r),
                    padding: const EdgeInsets.only(bottom: 5).r,
                    height: 100.r,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: FitTheme.textColor,
                      size: 40.r,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 45.r),
                      child: Text(
                        widget.equipmentType.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: FitTheme.textColor,
                          fontSize: 35.sp,
                          fontFamily: 'hofontmedium',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          toolbarHeight: 50,
          iconTheme: IconThemeData(color: FitTheme.textColor, size: 18),
          backgroundColor: FitTheme.backgroundColor,
          foregroundColor: Colors.black,
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildNewContainer(current),
                    _buildLastRecord(previous),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildNewContainer(SportHistory? record) {
    final r = record;
    return Container(
      margin: const EdgeInsets.all(25).r,
      alignment: Alignment.topCenter,
      child: Wrap(
        spacing: 20.r,
        runSpacing: 20.r,
        children: [
          _buildDataCard(
            '运动次数',
            '${r?.count ?? 0}',
            '次',
            'images/newUIScreen/icons/record_action.png',
          ),
          _buildDataCard(
            '时长',
            _formatDuration(r?.duringTime ?? 0),
            '分钟',
            'images/newUIScreen/icons/record_during.png',
          ),
          _buildDataCard(
            '卡路里',
            (r?.calories ?? 0).toStringAsFixed(0),
            'kcal',
            'images/newUIScreen/icons/record_heat.png',
          ),
          _buildDataCard(
            '平均心率',
            '--',
            'bpm',
            'images/newUIScreen/icons/record_heartBpm.png',
          ),
          _buildDataCard(
            '速度',
            _calcSpeed(r),
            '次/分钟',
            'images/newUIScreen/icons/record_speed.png',
          ),
          _buildDataCard(
            '运动模式',
            _getModeName(r?.mode ?? 0),
            '',
            'images/newUIScreen/icons/record_moden.png',
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(
    String title,
    String value,
    String unit,
    String iconAsset,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: FitTheme.secondbackGround,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
      width: 335.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 25.sp,
              fontFamily: 'hofontmedium',
              color: FitTheme.textColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: FitTheme.textColor,
                    fontSize: 50.sp,
                    fontFamily: 'BEBAS',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                height: 80.h,
                child: Image.asset(
                  iconAsset,
                  // color: FitTheme.textColor,
                  width: 100.r,
                  height: 100.r,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                unit,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontFamily: 'hofontmedium',
                  color: FitTheme.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLastRecord(SportHistory? previous) {
    final p = previous;
    return Card(
      color: FitTheme.secondbackGround,
      margin: const EdgeInsets.only(left: 25, right: 25, top: 0).r,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '上一次记录',
                    style: TextStyle(
                      fontSize: 25.sp,
                      color: FitTheme.textColor,
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: Text(
                      _formatDate(p?.startTime ?? ''),
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: FitTheme.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLastRecordItem('次数', '${p?.count ?? 0}'),
                  _buildLastRecordItem(
                    '时长',
                    _formatDuration(p?.duringTime ?? 0),
                  ),
                  _buildLastRecordItem(
                    '卡路里',
                    (p?.calories ?? 0).toStringAsFixed(0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastRecordItem(String title, String value) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(color: FitTheme.textColor, fontSize: 25.sp),
          ),
          Text(
            value,
            style: TextStyle(
              color: FitTheme.textColor,
              fontSize: 30.sp,
              fontFamily: 'BEBAS',
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _calcSpeed(SportHistory? r) {
    if (r == null || r.duringTime == 0) return '0';
    final speed = (r.count ?? 0) / (r.duringTime! / 60);
    return speed.toStringAsFixed(1);
  }

  String _getModeName(int mode) {
    switch (mode) {
      case 0:
        return '自由';
      case 1:
        return '模式一';
      case 2:
        return '模式二';
      default:
        return '自由';
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
