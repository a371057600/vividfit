import 'dart:typed_data';

/// FTMS 控制点(0x2AD9)回执结果码。
///
/// 定义于 FTMS 规范 Table 4.26 (Result Codes)。
enum FtmsControlResultCode {
  /// 成功。
  success(0x01),

  /// 不支持该 OpCode 或参数。
  notSupported(0x02),

  /// 无效参数。
  invalidParameter(0x03),

  /// 操作失败。
  operationFailed(0x04),

  /// 控制权限丢失(未请求或已被抢占)。
  controlPermissionLost(0x05);

  const FtmsControlResultCode(this.value);

  /// 规范定义的结果码原始值。
  final int value;

  /// 按原始值解析结果码,未知值返回 null。
  static FtmsControlResultCode? fromValue(int value) {
    switch (value) {
      case 0x01:
        return FtmsControlResultCode.success;
      case 0x02:
        return FtmsControlResultCode.notSupported;
      case 0x03:
        return FtmsControlResultCode.invalidParameter;
      case 0x04:
        return FtmsControlResultCode.operationFailed;
      case 0x05:
        return FtmsControlResultCode.controlPermissionLost;
      default:
        return null;
    }
  }
}

/// FTMS 控制点(0x2AD9)回执数据类。
///
/// 回执格式: `[0x80, requestOpCode, resultCode]`
/// - 0x80: Response OpCode(固定值,区别于请求指令)
/// - requestOpCode: 对应请求的 OpCode
/// - resultCode: 执行结果码
class FtmsControlResponse {
  /// 请求 OpCode(即回执对应的请求指令 OpCode)。
  final int requestOpCode;

  /// 执行结果码。
  final FtmsControlResultCode resultCode;

  const FtmsControlResponse({
    required this.requestOpCode,
    required this.resultCode,
  });

  /// 尝试解析控制点回执字节。
  ///
  /// 仅当满足以下条件时解析成功:
  /// - data 长度 >= 3
  /// - 首字节为 0x80(Response OpCode)
  /// - resultCode 可映射到 [FtmsControlResultCode]
  ///
  /// 任一条件不满足返回 null(非回执数据或未知结果码)。
  static FtmsControlResponse? tryParse(Uint8List data) {
    // 长度不足或首字节非 0x80(Response OpCode),视为非回执数据
    if (data.length < 3 || data[0] != 0x80) return null;

    final requestCode = FtmsControlResultCode.fromValue(data[2]);
    if (requestCode == null) return null;

    return FtmsControlResponse(
      requestOpCode: data[1],
      resultCode: requestCode,
    );
  }
}
