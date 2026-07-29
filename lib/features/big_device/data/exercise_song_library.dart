import '../../../core/ftms/ftms_device_type.dart';

/// 运动器械歌曲 URL 配置（1:1 迁移自旧 `song_list.dart` 的 `ExerciseSongs`，仅重命名）。
///
/// 歌曲数据完全不变，新增 `forType(FtmsDeviceType)` 方法替代旧的 switch case。
class ExerciseSongLibrary {
  ExerciseSongLibrary._();

  // 1. 跑步机歌曲列表
  static const List<String> treadmillSongs = [
    "https://gamifits.fitmonster.club/webres/mp3/Treadmill-song-1.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Treadmill-song-2.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Treadmill-song-3.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Treadmill-song-4.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Treadmill-song-5.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Treadmill-song-6.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Treadmill-song-7.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Treadmill-song-8.mp3",
  ];

  // 2. 单车歌曲列表
  static const List<String> bikeSongs = [
    "https://gamifits.fitmonster.club/webres/mp3/Bike-song-1.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Bike-song-2.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Bike-song-3.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Bike-song-4.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Bike-song-5.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Bike-song-6.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Bike-song-7.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Bike-song-8.mp3",
  ];

  // 3. 椭圆机歌曲列表
  static const List<String> ellipticalSongs = [
    "https://gamifits.fitmonster.club/webres/mp3/Elliptical-song-1.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Elliptical-song-2.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Elliptical-song-3.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Elliptical-song-4.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Elliptical-song-5.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Elliptical-song-6.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Elliptical-song-7.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Elliptical-song-8.mp3",
  ];

  // 4. 划船机歌曲列表
  static const List<String> rowingSongs = [
    "https://gamifits.fitmonster.club/webres/mp3/Rowing-song-1.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Rowing-song-2.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Rowing-song-3.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Rowing-song-4.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Rowing-song-5.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Rowing-song-6.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Rowing-song-7.mp3",
    "https://gamifits.fitmonster.club/webres/mp3/Rowing-song-8.mp3",
  ];

  /// 按设备类型获取歌曲列表。
  static List<String> forType(FtmsDeviceType type) {
    return switch (type) {
      FtmsDeviceType.indoorBike => bikeSongs,
      FtmsDeviceType.treadmill => treadmillSongs,
      FtmsDeviceType.crossTrainer => ellipticalSongs,
      FtmsDeviceType.rower => rowingSongs,
      FtmsDeviceType.strengthStation => bikeSongs,
    };
  }
}
