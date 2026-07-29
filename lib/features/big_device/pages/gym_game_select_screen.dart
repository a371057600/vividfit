import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';

/// 游戏选择页（对应旧 big_device_game_select.dart）
class GymGameSelectScreen extends ConsumerStatefulWidget {
  const GymGameSelectScreen({super.key});

  @override
  ConsumerState<GymGameSelectScreen> createState() => _GymGameSelectScreenState();
}

class _GymGameSelectScreenState extends ConsumerState<GymGameSelectScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // TODO: 实现游戏选择逻辑
    // - 游戏列表展示
    // - 音乐播放控制
    // - 运动数据展示

    return SafeArea(
      child: Scaffold(
        backgroundColor: FitTheme.backgroundColorOld,
        body: Stack(
          children: [
            // 主内容
            Container(
              margin: EdgeInsets.only(left: 120.w, right: 0.w),
              height: double.maxFinite,
              width: double.maxFinite,
              child: Row(
                children: [
                  _buildLeftContainer(l10n),
                  SizedBox(width: 10.w),
                  Expanded(child: _buildRightContainer(l10n)),
                ],
              ),
            ),
            // 返回按钮
            Positioned(
              top: 50.h,
              left: 10.w,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftContainer(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(top: 200.h),
      width: 0.5.sw,
      child: Column(
        children: [
          // 游戏选择区
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGameCard('${l10n.game} 1'),
              _buildGameCard('${l10n.game} 2'),
            ],
          ),
          SizedBox(height: 40.h),
          // 音乐选择区
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.r),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                children: List.generate(6, (index) {
                  return _buildMusicCard(l10n, index + 1);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(String title) {
    return Expanded(
      child: Container(
        height: 200.h,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: FitTheme.secondbackGroundOld,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildMusicCard(AppLocalizations l10n, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: FitTheme.secondbackGroundOld,
      ),
      child: Center(
        child: Text(
          '${l10n.music} $index',
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
      ),
    );
  }

  Widget _buildRightContainer(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(top: 200.h, right: 100.w),
      child: Column(
        children: [
          // 音乐播放控制
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                    onPressed: () {},
                  ),
                  SizedBox(width: 100.w),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white, size: 40),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.h),
          // 运动数据
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: FitTheme.secondbackGroundOld,
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDataItem(l10n.time, '00:00:00'),
                _buildDataItem(l10n.distance, '0.00 km'),
                _buildDataItem(l10n.calories, '0 kcal'),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          // 开始/停止按钮
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(300.w, 80.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            onPressed: () {},
            child: Text(l10n.start, style: TextStyle(fontSize: 20.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 10.sp)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
      ],
    );
  }
}