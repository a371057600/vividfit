import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/gym_device_connect_notifier_provider.dart';

/// 设备搜索对话框(对应旧 `showMyDialog`)。
///
/// 两态:
/// - 搜索中: RotateAnimation 持续旋转
/// - 设备列表: ListView.separated 显示广播名
///
/// 用 `StatefulBuilder` 驱动状态切换,不单独 StatefulWidget。
class DeviceSearchDialog extends ConsumerWidget {
  const DeviceSearchDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectState = ref.watch(gymDeviceConnectNotifierProvider);
    final connectNotifier = ref.read(gymDeviceConnectNotifierProvider.notifier);
    final tr = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: FitTheme.secondbackGroundOld,
      title: Text(
        tr.deviceConnection,
        style: TextStyle(
          color: FitTheme.textButtonColor,
          fontSize: FitTheme.fonSizeBig,
          fontFamily: FitTheme.fontFamily,
        ),
      ),
      content: SizedBox(
        width: 500.w,
        height: 300.h,
        child: StatefulBuilder(
          builder: (context, setState) {
            if (connectState.isSearching) {
              // ---- 搜索中态 ----
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: const AlwaysStoppedAnimation(0),
                    child: CircularProgressIndicator(
                      color: FitTheme.loadingColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    tr.deviceSelection,
                    style: TextStyle(
                      color: FitTheme.textButtonColor,
                      fontSize: FitTheme.fonSizeSmall,
                    ),
                  ),
                ],
              );
            }

            // ---- 设备列表态 ----
            if (connectState.foundDeviceNames.isEmpty) {
              return Center(
                child: Text(
                  'No devices found',
                  style: TextStyle(
                    color: FitTheme.textButtonColor,
                    fontSize: FitTheme.fonSizeSmall,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: connectState.foundDeviceNames.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final name = connectState.foundDeviceNames[index];
                return ListTile(
                  title: Text(
                    name,
                    style: TextStyle(
                      color: FitTheme.textButtonColor,
                      fontSize: FitTheme.fonSizeSmall,
                    ),
                  ),
                  onTap: () async {
                    await connectNotifier.connectSelectedDevice(name);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            connectNotifier.disconnectIfAny();
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: FitTheme.textButtonColor),
          ),
        ),
      ],
    );
  }
}
