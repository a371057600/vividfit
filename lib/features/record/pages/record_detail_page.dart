import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/them_change.dart';
import '../models/record_equipment_type.dart';

/// 记录详情页（空界面骨架）。
///
/// 对应旧项目 new_record_interface_second_level_screen.dart。
/// 当前阶段：仅 UI 骨架 + 占位数据，无网络请求。
/// 数据卡显示 0 占位，"上一次记录"区域显示占位。
class RecordDetailPage extends StatefulWidget {
  final RecordEquipmentType equipmentType;

  const RecordDetailPage({
    super.key,
    this.equipmentType = RecordEquipmentType.all,
  });

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildNewContainerPlaceholder(),
              _buildLastRecordPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  /// 当前记录数据卡区域（Wrap 占位）。
  Widget _buildNewContainerPlaceholder() {
    return Container(
      margin: const EdgeInsets.all(25).r,
      alignment: Alignment.topCenter,
      child: Wrap(
        spacing: 20.r,
        runSpacing: 20.r,
        children: [
          _buildDataCardPlaceholder('运动次数', '0', '次', Icons.repeat),
          _buildDataCardPlaceholder('时长', '00:00:00', '分钟', Icons.timer),
          _buildDataCardPlaceholder(
              '卡路里', '0', 'kcal', Icons.local_fire_department),
          _buildDataCardPlaceholder('平均心率', '--', 'bpm', Icons.favorite),
          _buildDataCardPlaceholder('速度', '0', '次/分钟', Icons.speed),
          _buildDataCardPlaceholder('运动模式', '自由', '', Icons.swap_horiz),
        ],
      ),
    );
  }

  Widget _buildDataCardPlaceholder(
      String title, String value, String unit, IconData icon) {
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
                child: Icon(
                  icon,
                  color: FitTheme.textColor,
                  size: 40,
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

  /// "上一次记录"对比卡占位。
  Widget _buildLastRecordPlaceholder() {
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
                      '2026/01/01',
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
                  _buildLastRecordItem('次数', '0'),
                  _buildLastRecordItem('时长', '00:00:00'),
                  _buildLastRecordItem('卡路里', '0'),
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
            style: TextStyle(
              color: FitTheme.textColor,
              fontSize: 25.sp,
            ),
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
}
