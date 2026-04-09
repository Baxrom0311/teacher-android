import 'teacher_model.dart';

int _profileInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String? _profileString(dynamic value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}

class TeacherCoauthorData {
  final int id;
  final String name;
  final String? phone;
  final String? passportNo;
  final String? email;

  const TeacherCoauthorData({
    required this.id,
    required this.name,
    this.phone,
    this.passportNo,
    this.email,
  });

  factory TeacherCoauthorData.fromJson(Map<String, dynamic> json) {
    return TeacherCoauthorData(
      id: _profileInt(json['id']),
      name: _profileString(json['name']) ?? '',
      phone: _profileString(json['phone']),
      passportNo: _profileString(json['passport_no']),
      email: _profileString(json['email']),
    );
  }
}

class TeacherProfileData {
  final int id;
  final int userId;
  final String? university;
  final String? graduationDate;
  final String? specialization;
  final String? address;
  final String? category;
  final String? gender;
  final String? achievements;
  final String? photoUrl;
  final String? diplomaUrl;
  final String? passportUrl;

  TeacherProfileData({
    required this.id,
    required this.userId,
    this.university,
    this.graduationDate,
    this.specialization,
    this.address,
    this.category,
    this.gender,
    this.achievements,
    this.photoUrl,
    this.diplomaUrl,
    this.passportUrl,
  });

  factory TeacherProfileData.fromJson(Map<String, dynamic> json) {
    return TeacherProfileData(
      id: _profileInt(json['id']),
      userId: _profileInt(json['user_id']),
      university: _profileString(json['university']),
      graduationDate: _profileString(json['graduation_date']),
      specialization: _profileString(json['specialization']),
      address: _profileString(json['address']),
      category: _profileString(json['category']),
      gender: _profileString(json['gender']),
      achievements: _profileString(json['achievements']),
      photoUrl: _profileString(json['photo_url']),
      diplomaUrl: _profileString(json['diploma_url']),
      passportUrl: _profileString(json['passport_url']),
    );
  }
}

class ScientificWorkData {
  final int id;
  final String title;
  final String? publishedAt;
  final String? publishedPlace;
  final String? fileUrl;
  final int createdBy;
  final List<TeacherCoauthorData> authors;

  ScientificWorkData({
    required this.id,
    required this.title,
    this.publishedAt,
    this.publishedPlace,
    this.fileUrl,
    required this.createdBy,
    required this.authors,
  });

  factory ScientificWorkData.fromJson(Map<String, dynamic> json) {
    return ScientificWorkData(
      id: _profileInt(json['id']),
      title: _profileString(json['title']) ?? '',
      publishedAt: _profileString(json['published_at']),
      publishedPlace: _profileString(json['published_place']),
      fileUrl: _profileString(json['file_url']),
      createdBy: _profileInt(json['created_by']),
      authors:
          (json['authors'] as List?)
              ?.map(
                (item) => TeacherCoauthorData.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class ProfileResponse {
  final TeacherModel teacher;
  final TeacherProfileData? profile;
  final List<ScientificWorkData> works;
  final bool canEdit;

  ProfileResponse({
    required this.teacher,
    this.profile,
    required this.works,
    required this.canEdit,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      teacher: TeacherModel.fromJson(
        Map<String, dynamic>.from(json['teacher'] as Map? ?? const {}),
      ),
      profile: json['profile'] != null
          ? TeacherProfileData.fromJson(
              Map<String, dynamic>.from(json['profile'] as Map),
            )
          : null,
      works:
          (json['works'] as List?)
              ?.map(
                (item) => ScientificWorkData.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
      canEdit: json['can_edit'] ?? false,
    );
  }
}
