import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/them_change.dart';
import '../../../l10n/app_localizations.dart';
import '../notifiers/gym_device_connect_notifier.dart';

/// 设备搜索对话框(1:1 还原旧 `controller_new_four_big_device_sprot.dart` 的 Get.dialog)。
///
/// 双态弹窗:
/// 1. 搜索中态:透明背景 + 居中 CircularProgressIndicator(白色, strokeWidth:2)
///    - **仅在搜索中且无设备时显示 Loading**
/// 2. 设备列表态:secondbackGround 背景 + Row(标题+关闭按钮) + ListView(设备名)
///    - **发现设备立即显示列表，支持追加**
///
/// 还原点:
/// - 搜索中:backgroundColor:transparent, content: Container(300x300 CircularProgressIndicator)
/// - 列表态:backgroundColor:secondbackGround, title:Row(Expanded+Text+IconButton close)
/// - 列表 content: Container(height:屏幕*0.5, width:屏幕*0.5) + ListView
/// - 设备项:ListTile(title: Text(advName, fontSize:18.sp, bold, textColor))
/// - 关闭按钮:IconButton(Icons.close, size:30.sp, textColor)
class DeviceSearchDialog extends ConsumerWidget {
  const DeviceSearchDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectState = ref.watch(gymDeviceConnectProvider);
    final connectNotifier = ref.read(gymDeviceConnectProvider.notifier);
    final tr = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // ✅ 修复:仅在搜索中且无设备时显示 Loading
    // 发现第一个设备后立即切换到列表视图
    if (connectState.isSearching && connectState.foundDeviceNames.isEmpty) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        title: const Center(child: Text('')),
        content: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          height: 400.h,
          width: 400.h,
          child: Container(
            width: 300.h,
            height: 300.h,
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
              trackGap: 10,
            ),
          ),
        ),
      );
    }

    // ✅ 发现设备立即显示列表（即使扫描未结束）
    return AlertDialog(
      backgroundColor: FitTheme.secondbackGround,
      title: Row(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            child: Text(
              tr.deviceSelection,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: FitTheme.textColor,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: screenWidth * 0.2,
            height: 200.h,
            color: FitTheme.secondbackGround,
            child: IconButton(
              onPressed: () async {
                // ✅ 关闭时停止扫描和断开连接
                await connectNotifier.stopScan();
                connectNotifier.disconnectIfAny();
                if (context.mounted) Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: FitTheme.textColor,
                size: 30.sp,
              ),
            ),
          ),
        ],
      ),
      content: Container(
        alignment: Alignment.center,
        color: FitTheme.secondbackGround,
        height: screenHeight * 0.5,
        width: screenWidth * 0.5,
        child: connectState.foundDeviceNames.isEmpty
            ? Text(
                tr.noDevicesFound,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: FitTheme.textColor,
                ),
              )
            : ListView.builder(
                itemCount: connectState.foundDeviceNames.length,
                itemBuilder: (context, index) {
                  final name = connectState.foundDeviceNames[index];
                  return InkWell(
                    onTap: () async {
                      // ✅ 选择设备：先停止扫描再连接
                      await connectNotifier.stopScan();
                      await connectNotifier.connectSelectedDevice(name);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: ListTile(
                      title: Text(
                        name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: FitTheme.textColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
