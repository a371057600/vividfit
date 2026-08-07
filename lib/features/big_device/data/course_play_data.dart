/// 课程播放数据 JSON 模型(1:1 迁移自旧 `model/course_play_data.dart`)。
///
/// 对应远程 JSON: `coursePlayDataBike.json` / `coursePlayDataRun.json` 等,
/// 结构: `{ "dataList": [ { "id":..., "titleProperties":..., "courseProperties":...,
///          "barLineDtaList":[ { "stageName":..., "imageProperties":...,
///          "voiceProperties":[...], "bgmProperties":... } ] } ] }`
///
/// 与 `course_catalog.dart`(课程目录列表)的区别:
/// - `CourseCatalog` 对应 `courseTypeList*.json`,是课程分类+列表(courseId/name/imagePath)
/// - 本文件对应 `coursePlayData*.json`,是单个课程的播放数据(含 barLine 动作序列)
class CoursePlayData {
  List<CourseItem>? dataList;

  CoursePlayData({this.dataList});

  factory CoursePlayData.fromJson(Map<String, dynamic> json) {
    return CoursePlayData(
      dataList:
          (json['dataList'] as List<dynamic>?)
              ?.map((e) => CourseItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'dataList': dataList?.map((e) => e.toJson()).toList()};
  }
}

class CourseItem {
  int? id;
  TitleProperties? titleProperties;
  DeviceProperties? deviceProperties;
  CourseProperties? courseProperties;
  List<BarLineData>? barLineDtaList;

  CourseItem({
    this.id,
    this.titleProperties,
    this.deviceProperties,
    this.courseProperties,
    this.barLineDtaList,
  });

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      id: json['id'] as int?,
      titleProperties:
          json['titleProperties'] != null
              ? TitleProperties.fromJson(
                json['titleProperties'] as Map<String, dynamic>,
              )
              : null,
      deviceProperties:
          json['deviceProperties'] != null
              ? DeviceProperties.fromJson(
                json['deviceProperties'] as Map<String, dynamic>,
              )
              : null,
      courseProperties:
          json['courseProperties'] != null
              ? CourseProperties.fromJson(
                json['courseProperties'] as Map<String, dynamic>,
              )
              : null,
      barLineDtaList:
          (json['barLineDtaList'] as List<dynamic>?)
              ?.map((e) => BarLineData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleProperties': titleProperties?.toJson(),
      'deviceProperties': deviceProperties?.toJson(),
      'courseProperties': courseProperties?.toJson(),
      'barLineDtaList': barLineDtaList?.map((e) => e.toJson()).toList(),
    };
  }
}

class TitleProperties {
  String? bigTitle;
  String? smallTitle;
  String? level;
  String? difficulty;

  TitleProperties({this.bigTitle, this.smallTitle, this.level, this.difficulty});

  factory TitleProperties.fromJson(Map<String, dynamic> json) {
    return TitleProperties(
      bigTitle: json['bigTitle'] as String?,
      smallTitle: json['smallTitle'] as String?,
      level: json['level'] as String?,
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bigTitle': bigTitle,
      'smallTitle': smallTitle,
      'level': level,
      'difficulty': difficulty,
    };
  }
}

class DeviceProperties {
  String? name;
  String? brand;
  int? type;

  DeviceProperties({this.name, this.brand, this.type});

  factory DeviceProperties.fromJson(Map<String, dynamic> json) {
    return DeviceProperties(
      name: json['name'] as String?,
      brand: json['brand'] as String?,
      type: json['type'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'brand': brand, 'type': type};
  }
}

class CourseProperties {
  String? name;
  int? time;
  String? level;
  String? imagePath;
  int? courseType;
  String? details;
  String? notes;
  String? suggestions;
  bool? isAllowShowProgressBar;

  CourseProperties({
    this.name,
    this.time,
    this.level,
    this.imagePath,
    this.courseType,
    this.details,
    this.notes,
    this.suggestions,
    this.isAllowShowProgressBar,
  });

  factory CourseProperties.fromJson(Map<String, dynamic> json) {
    return CourseProperties(
      name: json['name'] as String?,
      time: json['time'] as int?,
      level: json['level'] as String?,
      imagePath: json['imagePath'] as String?,
      courseType: json['courseType'] as int?,
      details: json['details'] as String?,
      notes: json['notes'] as String?,
      suggestions: json['suggestions'] as String?,
      isAllowShowProgressBar: json['isAllowShowProgressBar'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time,
      'level': level,
      'imagePath': imagePath,
      'courseType': courseType,
      'details': details,
      'notes': notes,
      'suggestions': suggestions,
      'isAllowShowProgressBar': isAllowShowProgressBar,
    };
  }
}

class BarLineData {
  int? count;
  int? duration;
  int? posture;
  int? resistance;
  int? cadence;
  int? gradient;
  int? distance;
  String? stageName;
  bool? isRestStage;
  List<VoiceProperty>? voiceProperties;
  BgmProperties? bgmProperties;
  ImageProperties? imageProperties;
  int? orderId;

  BarLineData({
    this.count,
    this.duration,
    this.posture,
    this.resistance,
    this.cadence,
    this.gradient,
    this.distance,
    this.stageName,
    this.isRestStage,
    this.voiceProperties,
    this.bgmProperties,
    this.imageProperties,
    this.orderId,
  });

  factory BarLineData.fromJson(Map<String, dynamic> json) {
    return BarLineData(
      count: json['count'] as int?,
      duration: json['duration'] as int?,
      posture: json['posture'] as int?,
      resistance: json['resistance'] as int?,
      cadence: json['cadence'] as int?,
      gradient: json['gradient'] as int?,
      distance: json['distance'] as int?,
      stageName: json['stageName'] as String?,
      isRestStage: json['isRestStage'] as bool?,
      orderId: json['orderId'] as int?,
      voiceProperties:
          (json['voiceProperties'] as List<dynamic>?)
              ?.map((e) => VoiceProperty.fromJson(e as Map<String, dynamic>))
              .toList(),
      bgmProperties:
          json['bgmProperties'] != null
              ? BgmProperties.fromJson(
                json['bgmProperties'] as Map<String, dynamic>,
              )
              : null,
      imageProperties:
          json['imageProperties'] != null
              ? ImageProperties.fromJson(
                json['imageProperties'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'duration': duration,
      'orderId': orderId,
      'posture': posture,
      'resistance': resistance,
      'cadence': cadence,
      'gradient': gradient,
      'distance': distance,
      'stageName': stageName,
      'isRestStage': isRestStage,
      'voiceProperties': voiceProperties?.map((e) => e.toJson()).toList(),
      'bgmProperties': bgmProperties?.toJson(),
      'imageProperties': imageProperties?.toJson(),
    };
  }
}

class VoiceProperty {
  String? name;
  String? downLoadPath;
  String? type;
  String? dialect;

  VoiceProperty({this.name, this.downLoadPath, this.type, this.dialect});

  factory VoiceProperty.fromJson(Map<String, dynamic> json) {
    return VoiceProperty(
      name: json['name'] as String?,
      downLoadPath: json['downLoadPath'] as String?,
      type: json['type'] as String?,
      dialect: json['dialect'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'downLoadPath': downLoadPath,
      'type': type,
      'dialect': dialect,
    };
  }
}

class BgmProperties {
  String? name;
  String? downLoadPath;

  BgmProperties({this.name, this.downLoadPath});

  factory BgmProperties.fromJson(Map<String, dynamic> json) {
    return BgmProperties(
      name: json['name'] as String?,
      downLoadPath: json['downLoadPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'downLoadPath': downLoadPath};
  }
}

class ImageProperties {
  String? name;
  String? imagePathName;
  String? downLoadPath;
  String? imagePath;
  int? imagefps;
  int? count;
  int? width;
  int? height;

  ImageProperties({
    this.name,
    this.downLoadPath,
    this.imagePath,
    this.imagefps,
    this.count,
    this.width,
    this.imagePathName,
    this.height,
  });

  factory ImageProperties.fromJson(Map<String, dynamic> json) {
    return ImageProperties(
      name: json['name'] as String?,
      downLoadPath: json['downLoadPath'] as String?,
      imagePath: json['imagePath'] as String?,
      imagefps: json['imagefps'] as int?,
      count: json['count'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      imagePathName: json['imagePathName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'downLoadPath': downLoadPath,
      'imagePath': imagePath,
      'imagefps': imagefps,
      'count': count,
      'width': width,
      'height': height,
      'imagePathName': imagePathName,
    };
  }
}
