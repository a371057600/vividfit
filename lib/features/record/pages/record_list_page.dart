import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';

import '../../../core/constants/them_change.dart';
import '../models/record_equipment_type.dart';
import 'widgets/empty_data_widget.dart';

/// 记录列表页（空界面骨架）。
///
/// 对应旧项目 new_record_list_screen.dart。
/// 当前阶段：仅 UI 骨架 + 占位数据，无网络请求。
/// 年度总览显示 0，列表区域显示"暂无运动记录"占位。
class RecordListPage extends StatefulWidget {
  const RecordListPage({super.key});

  @override
  State<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
  int _titleYear = DateTime.now().year;
  int _selectedEquipmentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
              onTap: () => _showEquipmentSelector(),
              child: Container(
                alignment: Alignment.bottomRight,
                height: MediaQuery.of(context).size.height * 0.12,
                width: 250.r,
                margin: const EdgeInsets.only(right: 45, bottom: 20).r,
                child: Text(
                  RecordEquipmentType.values[_selectedEquipmentIndex].displayName,
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
        body: _buildMainBody(),
      ),
    );
  }

  Widget _buildMainBody() {
    return Container(
      color: FitTheme.backgroundColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          _buildHeaderWidget(),
          EmptyDataWidget(
            message: '暂无运动记录',
            iconPath: 'images/newUIScreen/icons/icon_noInetrnet.png',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildYearSelector(),
          SizedBox(height: 20.h),
          _buildHeaderDataRow(),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20).r,
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: _titleYear > 2021 ? () => setState(() => _titleYear--) : null,
            child: Icon(Icons.arrow_back_ios, size: 40.sp),
          ),
          Text(
            '$_titleYear 年度总览',
            style: TextStyle(
              color: FitTheme.textColor,
              fontFamily: 'hofontmedium',
              fontSize: 25.sp,
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: _titleYear < DateTime.now().year
                ? () => setState(() => _titleYear++)
                : null,
            child: Icon(Icons.arrow_forward_ios_sharp, size: 40.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDataRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeaderDataWidget('0', '总运动次数', Alignment.centerLeft),
        _buildHeaderDataWidget('0', '总时长', Alignment.center),
        _buildHeaderDataWidget('0', '总消耗', Alignment.centerRight),
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

  /// 设备筛选 BottomSheet（5 个设备类型）。
  void _showEquipmentSelector() {
    int tempIndex = _selectedEquipmentIndex;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
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
                  tempIndex = index;
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
                setState(() => _selectedEquipmentIndex = tempIndex);
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
    );
  }
}
