import 'teacher_model.dart';

class LoginResponse {
  final String centralToken;
  final TeacherModel user;
  final List<SchoolModel> schools;
  final TenantSession? autoTenant;

  LoginResponse({
    required this.centralToken,
    required this.user,
    required this.schools,
    this.autoTenant,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      centralToken: json['token']?.toString() ?? '',
      user: TeacherModel.fromJson(json['user'] ?? {}),
      schools: (json['schools'] as List? ?? [])
          .map((s) => SchoolModel.fromJson(s))
          .toList(),
      autoTenant: json['tenant'] != null 
          ? TenantSession.fromJson(json['tenant']) 
          : null,
    );
  }
}

class SchoolModel {
  final int? membershipId;
  final String? tenantId;
  final String schoolName;
  final String host;
  final String? logo;

  SchoolModel({
    this.membershipId,
    this.tenantId,
    required this.schoolName,
    required this.host,
    this.logo,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      membershipId: (json['membership_id'] as num?)?.toInt(),
      tenantId: (json['tenant_id'] ?? json['id'])?.toString(),
      schoolName: (json['school_name'] ?? json['name'])?.toString() ?? '',
      host: json['host']?.toString() ?? '',
      logo: json['logo']?.toString(),
    );
  }
}

class TenantSession {
  final String? tenantId;
  final String host;
  final String token;

  TenantSession({
    this.tenantId,
    required this.host,
    required this.token,
  });

  factory TenantSession.fromJson(Map<String, dynamic> json) {
    return TenantSession(
      tenantId: json['tenant_id']?.toString(),
      host: json['host']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
    );
  }
}
