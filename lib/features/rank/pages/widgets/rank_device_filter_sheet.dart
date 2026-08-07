import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/them_change.dart';
import '../../domain/rank_device_type.dart';

class RankDeviceFilterSheet extends StatelessWidget {
  final RankDeviceType currentType;
  final Function(RankDeviceType) onChanged;

  const RankDeviceFilterSheet({
    super.key,
    required this.currentType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final devices = RankDeviceType.values;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30).r,
          topRight: Radius.circular(30).r,
        ),
      ),
      padding: EdgeInsets.only(
        left: 30.r,
        right: 30.r,
        top: 30.r,
        bottom: MediaQuery.of(context).viewInsets.bottom + 50.r,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Device',
            style: TextStyle(
              color: FitTheme.textColor,
              fontSize: 35.sp,
              fontFamily: AppFonts.hofontmedium,
            ),
          ),
          const SizedBox(height: 20),
          ...devices.map((device) {
            final isSelected = currentType == device;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8).r,
              child: InkWell(
                onTap: () => onChanged(device),
                child: Container(
                  width: double.infinity,
                  height: 90.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.grey.shade200
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15).r,
                    border: isSelected
                        ? Border.all(color: Colors.red, width: 1.5)
                        : Border.all(color: Colors.grey.shade300, width: 0.5),
                  ),
                  child: Text(
                    device.displayName,
                    style: TextStyle(
                      color: FitTheme.textColor,
                      fontSize: 28.sp,
                      fontFamily: AppFonts.hofontmedium,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
