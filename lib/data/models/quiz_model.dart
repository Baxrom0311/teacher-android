class TeacherQuizModel {
  final int id;
  final String title;
  final String? description;
  final String? subjectName;
  final int? timeLimitMinutes;
  final int maxScore;
  final bool isActive;
  final int attemptsCount;
  final String? availableFrom;
  final String? availableUntil;
  final String? createdAt;

  TeacherQuizModel({
    required this.id,
    required this.title,
    this.description,
    this.subjectName,
    this.timeLimitMinutes,
    this.maxScore = 0,
    this.isActive = true,
    this.attemptsCount = 0,
    this.availableFrom,
    this.availableUntil,
    this.createdAt,
  });

  factory TeacherQuizModel.fromJson(Map<String, dynamic> json) {
    return TeacherQuizModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      subjectName: json['subject_name'] as String?,
      timeLimitMinutes: json['time_limit_minutes'] as int?,
      maxScore: json['max_score'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      attemptsCount: json['attempts_count'] as int? ?? 0,
      availableFrom: json['available_from'] as String?,
      availableUntil: json['available_until'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}

class QuizResultModel {
  final int totalAttempts;
  final double avgScore;
  final double avgPercent;
  final List<QuizAttemptSummary> attempts;

  QuizResultModel({
    this.totalAttempts = 0,
    this.avgScore = 0,
    this.avgPercent = 0,
    this.attempts = const [],
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      totalAttempts: json['total_attempts'] as int? ?? 0,
      avgScore: (json['avg_score'] as num?)?.toDouble() ?? 0,
      avgPercent: (json['avg_percent'] as num?)?.toDouble() ?? 0,
      attempts: (json['attempts'] as List?)
              ?.map((e) => QuizAttemptSummary.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}

class QuizAttemptSummary {
  final int id;
  final String? studentName;
  final int score;
  final int maxScore;
  final double percent;
  final String? finishedAt;

  QuizAttemptSummary({
    required this.id,
    this.studentName,
    this.score = 0,
    this.maxScore = 0,
    this.percent = 0,
    this.finishedAt,
  });

  factory QuizAttemptSummary.fromJson(Map<String, dynamic> json) {
    return QuizAttemptSummary(
      id: json['id'] as int,
      studentName: json['student_name'] as String?,
      score: json['score'] as int? ?? 0,
      maxScore: json['max_score'] as int? ?? 0,
      percent: (json['percent'] as num?)?.toDouble() ?? 0,
      finishedAt: json['finished_at'] as String?,
    );
  }
}
