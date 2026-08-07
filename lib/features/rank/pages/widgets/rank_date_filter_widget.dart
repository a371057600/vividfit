import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/them_change.dart';
import '../../domain/rank_device_type.dart';

class RankDateFilterWidget extends StatelessWidget {
  final RankTimeRange currentRange;
  final Function(RankTimeRange) onChanged;

  const RankDateFilterWidget({
    super.key,
    required this.currentRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (RankTimeRange.total, 'Total'),
      (RankTimeRange.annual, 'Annual'),
      (RankTimeRange.monthly, 'Monthly'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        final isSelected = currentRange == item.$1;
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => onChanged(item.$1),
          child: Container(
            height: 80.h,
            width: 180.w,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 3).r,
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(color: Colors.red, width: 1)
                  : null,
              color: FitTheme.secondbackGround,
              borderRadius: BorderRadius.circular(30).r,
            ),
            child: Text(
              item.$2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: FitTheme.textColor,
                fontSize: 25.sp,
                fontFamily: AppFonts.hofontmedium,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
