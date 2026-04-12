class TeacherModel {
  final int id;
  final String? tenantId;
  final String name;
  final String email;
  final String? phone;
  final String? passportNo;
  final String role;

  TeacherModel({
    required this.id,
    this.tenantId,
    required this.name,
    required this.email,
    this.phone,
    this.passportNo,
    required this.role,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      tenantId: json['tenant_id']?.toString(),
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
      'tenant_id': tenantId,
      'name': name,
      'email': email,
      'phone': phone,
      'passport_no': passportNo,
      'role': role,
    };
  }
}
