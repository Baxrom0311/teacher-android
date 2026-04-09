class TeacherModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? passportNo;
  final String role;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.passportNo,
    required this.role,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      passportNo: json['passport_no']?.toString(),
      role: json['role']?.toString() ?? 'teacher',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'passport_no': passportNo,
      'role': role,
    };
  }
}
