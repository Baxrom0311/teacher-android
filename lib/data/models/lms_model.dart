class CourseModel {
  final int id;
  final String title;
  final String? description;
  final String status;
  final int teacherId;

  CourseModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.teacherId,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'draft',
      teacherId: json['teacher_id'] ?? 0,
    );
  }
}

class CourseSectionModel {
  final int id;
  final int courseId;
  final String title;
  final int orderNum;

  CourseSectionModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.orderNum,
  });

  factory CourseSectionModel.fromJson(Map<String, dynamic> json) {
    return CourseSectionModel(
      id: json['id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      title: json['title'] ?? '',
      orderNum: json['order_num'] ?? 0,
    );
  }
}

class CourseMaterialModel {
  final int id;
  final int sectionId;
  final String title;
  final String type;
  final String contentUrl;

  CourseMaterialModel({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.type,
    required this.contentUrl,
  });

  factory CourseMaterialModel.fromJson(Map<String, dynamic> json) {
    return CourseMaterialModel(
      id: json['id'] ?? 0,
      sectionId: json['section_id'] ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? 'document',
      contentUrl: json['content_url'] ?? '',
    );
  }
}
