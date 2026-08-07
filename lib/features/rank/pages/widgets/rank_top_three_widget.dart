import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/them_change.dart';
import '../../data/models/rank_leaderboard_entity.dart';
import '../../domain/rank_device_type.dart';
import 'rank_avatar_widget.dart';

class RankTopThreeWidget extends StatelessWidget {
  final List<RankLeaderboardEntity> topThree;
  final RankDeviceType deviceType;

  const RankTopThreeWidget({
    super.key,
    required this.topThree,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    if (topThree.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 15).r,
      height: 310.h,
      width: double.infinity,
      child: _buildLayout(),
    );
  }

  Widget _buildLayout() {
    final length = topThree.length;
    if (length == 1) return _buildBigMedalWidget(topThree[0]);
    if (length == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSmallMedalWidget(topThree[1], 1),
          _buildBigMedalWidget(topThree[0]),
          SizedBox(width: 200.w),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSmallMedalWidget(topThree[2], 1),
        _buildBigMedalWidget(topThree[0]),
        _buildSmallMedalWidget(topThree[1], 2),
      ],
    );
  }

  Widget _buildBigMedalWidget(RankLeaderboardEntity entity) {
    return SizedBox(
      height: 250.r,
      width: 300.r,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20).r,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                height: 140.r,
                width: 140.r,
                child: entity.headImg == null || entity.headImg!.isEmpty
                    ? Image.asset(
                        'images/newUIScreen/defaultheadimages/deheadImage8.jpg',
                        fit: BoxFit.cover,
                      )
                    : RankAvatarWidget(
                        headImgHash: entity.headImg,
                        size: 280,
                      ),
              ),
              ExtendedImage.asset(
                'images/newUIScreen/icons/icon_rank_1.png',
                height: 160.r,
                width: 160.r,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5).r,
            child: Column(
              children: [
                Text(
                  entity.nickName,
                  maxLines: 1,
                  style: TextStyle(
                    height: 1,
                    color: FitTheme.textColor,
                    fontSize: 25.sp,
                  ),
                ),
                Text(
                  deviceType == RankDeviceType.all
                      ? entity.calories.toStringAsFixed(0)
                      : entity.count.toStringAsFixed(0),
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: AppFonts.bebas,
                    color: FitTheme.textColor,
                    fontSize: 35.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMedalWidget(RankLeaderboardEntity entity, int medalIndex) {
    return Container(
      padding: const EdgeInsets.only(top: 30).r,
      alignment: Alignment.center,
      height: 280.r,
      width: 180.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 130.r,
            height: medalIndex == 1 ? 130.r : 150.r,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SizedBox(height: 140.r, width: 140.r),
                Positioned(
                  child: Container(
                    height: 110.r,
                    width: 110.r,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FitTheme.textColor,
                    ),
                    child: entity.headImg == null || entity.headImg!.isEmpty
                        ? Image.asset(
                            'images/newUIScreen/defaultheadimages/deheadImage8.jpg',
                            fit: BoxFit.cover,
                          )
                        : RankAvatarWidget(
                            headImgHash: entity.headImg,
                            size: 220,
                          ),
                  ),
                ),
                ExtendedImage.asset(
                  'images/newUIScreen/icons/icon_rank_${medalIndex + 2}.png',
                  width: 200.r,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15).r,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    entity.nickName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      height: 1,
                      fontSize: 25.sp,
                    ),
                  ),
                  Text(
                    deviceType == RankDeviceType.all
                        ? entity.calories.toStringAsFixed(0)
                        : entity.count.toStringAsFixed(0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.bebas,
                      color: FitTheme.textColor,
                      fontSize: 35.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
