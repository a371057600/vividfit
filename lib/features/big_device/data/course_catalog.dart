/// 课程目录模型(1:1 迁移自旧 `course_type.dart` 的 `CourseTypeList`,仅重命名)。
///
/// 对应 JSON 结构:
/// `{ "dataList": [ { "name": ..., "type": ..., "courseList": [...] } ] }`
class CourseCatalog {
  final List<CourseCategory>? categories;

  CourseCatalog({this.categories});

  factory CourseCatalog.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? dataListJson = json['dataList'] as List<dynamic>?;
    final List<CourseCategory>? categories =
        dataListJson == null || dataListJson.isEmpty
            ? null
            : dataListJson
                .map((item) =>
                    CourseCategory.fromJson(item as Map<String, dynamic>))
                .toList();

    return CourseCatalog(categories: categories);
  }

  Map<String, dynamic> toJson() {
    return {
      'dataList':
          categories?.map((category) => category.toJson()).toList() ?? [],
    };
  }
}

/// 课程分类模型(1:1 迁移自旧 `CourseType`,仅重命名)。
class CourseCategory {
  final String? name;
  final int? type;
  final List<CourseEntry>? courseList;

  CourseCategory({this.name, this.type, this.courseList});

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? courseListJson = json['courseList'];
    final List<CourseEntry>? courseList =
        courseListJson == null || courseListJson.isEmpty
            ? null
            : courseListJson
                .map((course) => CourseEntry.fromJson(course))
                .toList();

    return CourseCategory(
      name: json['name'] as String?,
      type: json['type'] as int?,
      courseList: courseList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    if (courseList != null) {
      data['courseList'] = courseList?.map((course) => course.toJson()).toList();
    } else {
      data['courseList'] = [];
    }
    return data;
  }
}

/// 课程项模型(1:1 迁移自旧 `CourseItem`,仅重命名)。
class CourseEntry {
  final String? name;
  final String? imagePath;
  final int? courseId;

  CourseEntry({this.name, this.imagePath, this.courseId});

  factory CourseEntry.fromJson(Map<String, dynamic> json) {
    return CourseEntry(
      name: json['name'] as String?,
      imagePath: json['imagePath'] as String?,
      courseId: json['courseId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['imagePath'] = imagePath;
    data['courseId'] = courseId;
    return data;
  }
}
