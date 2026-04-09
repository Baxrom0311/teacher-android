class StudentPayment {
  final int id;
  final int studentId;
  final int groupId;
  final String payType; // 'monthly', 'yearly'
  final String paymentMethod; // 'cash', 'card', 'p2p', 'terminal'
  final int? periodYear;
  final int? periodMonth;
  final num amount;
  final String paidAt;
  final String? note;

  StudentPayment({
    required this.id,
    required this.studentId,
    required this.groupId,
    required this.payType,
    required this.paymentMethod,
    this.periodYear,
    this.periodMonth,
    required this.amount,
    required this.paidAt,
    this.note,
  });

  factory StudentPayment.fromJson(Map<String, dynamic> json) {
    return StudentPayment(
      id: json['id'],
      studentId: json['student_id'],
      groupId: json['group_id'],
      payType: json['pay_type'],
      paymentMethod: json['payment_method'],
      periodYear: json['period_year'],
      periodMonth: json['period_month'],
      amount: json['amount'],
      paidAt: json['paid_at'],
      note: json['note'],
    );
  }
}

class GroupData {
  final int id;
  final String name;

  GroupData({required this.id, required this.name});

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(id: json['id'], name: json['name']);
  }
}

class StudentData {
  final int studentId;
  final String studentName;
  final String? studentPhone;
  final int groupId;
  final String groupName;
  final bool isPaid; // Derived field from paid_student_ids

  StudentData({
    required this.studentId,
    required this.studentName,
    this.studentPhone,
    required this.groupId,
    required this.groupName,
    this.isPaid = false,
  });

  factory StudentData.fromJson(Map<String, dynamic> json, List<int> paidIds) {
    final int id = json['student_id'] ?? json['id'];
    return StudentData(
      studentId: id,
      studentName: json['student_name'] ?? json['name'] ?? '',
      studentPhone: json['student_phone'] ?? json['phone'],
      groupId: json['group_id'] ?? 0,
      groupName: json['group_name'] ?? '',
      isPaid: paidIds.contains(id),
    );
  }
}

class PaymentsIndexResponse {
  final List<StudentData> students;
  final List<GroupData> groups;
  final int groupId;
  final String search;
  final List<int> paidStudentIds;
  final int month;
  final int year;

  PaymentsIndexResponse({
    required this.students,
    required this.groups,
    required this.groupId,
    required this.search,
    required this.paidStudentIds,
    required this.month,
    required this.year,
  });

  factory PaymentsIndexResponse.fromJson(Map<String, dynamic> json) {
    final paidIds =
        (json['paid_student_ids'] as List?)?.map((e) => e as int).toList() ??
        [];
    return PaymentsIndexResponse(
      groups:
          (json['groups'] as List?)
              ?.map((e) => GroupData.fromJson(e))
              .toList() ??
          [],
      groupId: json['group_id'] ?? 0,
      search: json['search'] ?? '',
      paidStudentIds: paidIds,
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      students:
          (json['students'] as List?)
              ?.map((e) => StudentData.fromJson(e, paidIds))
              .toList() ??
          [],
    );
  }
}

class StudentPaymentDetailResponse {
  final Map<String, dynamic> student;
  final Map<String, dynamic> group;
  final List<StudentPayment> payments;
  final num defaultAmount;
  final num monthlyFee;
  final num discountAmount;
  final List<dynamic> discountReasons;

  StudentPaymentDetailResponse({
    required this.student,
    required this.group,
    required this.payments,
    required this.defaultAmount,
    required this.monthlyFee,
    required this.discountAmount,
    required this.discountReasons,
  });

  factory StudentPaymentDetailResponse.fromJson(Map<String, dynamic> json) {
    return StudentPaymentDetailResponse(
      student: json['student'] ?? {},
      group: json['group'] ?? {},
      payments:
          (json['payments'] as List?)
              ?.map((e) => StudentPayment.fromJson(e))
              .toList() ??
          [],
      defaultAmount: json['default_amount'] ?? 0,
      monthlyFee: json['monthly_fee'] ?? 0,
      discountAmount: json['discount_amount'] ?? 0,
      discountReasons: json['discount_reasons'] ?? [],
    );
  }
}
