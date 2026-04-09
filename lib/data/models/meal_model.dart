class MealGroupData {
  final int id;
  final String name;

  MealGroupData({required this.id, required this.name});

  factory MealGroupData.fromJson(Map<String, dynamic> json) {
    return MealGroupData(id: json['id'], name: json['name']);
  }
}

class MealReportMedia {
  final int id;
  final String filePath;
  final String originalName;
  final String mime;
  final int size;

  MealReportMedia({
    required this.id,
    required this.filePath,
    required this.originalName,
    required this.mime,
    required this.size,
  });

  factory MealReportMedia.fromJson(Map<String, dynamic> json) {
    return MealReportMedia(
      id: json['id'],
      filePath: json['file_path'],
      originalName: json['original_name'],
      mime: json['mime'],
      size: json['size'],
    );
  }
}

class MealReportData {
  final int id;
  final int groupId;
  final String mealDate;
  final String? breakfastName;
  final String? breakfastRecipe;
  final String? lunchName;
  final String? lunchRecipe;
  final String? dinnerName;
  final String? dinnerRecipe;

  MealReportData({
    required this.id,
    required this.groupId,
    required this.mealDate,
    this.breakfastName,
    this.breakfastRecipe,
    this.lunchName,
    this.lunchRecipe,
    this.dinnerName,
    this.dinnerRecipe,
  });

  factory MealReportData.fromJson(Map<String, dynamic> json) {
    return MealReportData(
      id: json['id'],
      groupId: json['group_id'],
      mealDate: json['meal_date'],
      breakfastName: json['breakfast_name'],
      breakfastRecipe: json['breakfast_recipe'],
      lunchName: json['lunch_name'],
      lunchRecipe: json['lunch_recipe'],
      dinnerName: json['dinner_name'],
      dinnerRecipe: json['dinner_recipe'],
    );
  }
}

class MealIndexResponse {
  final List<MealGroupData> groups;
  final MealGroupData? currentGroup;
  final int groupId;
  final MealReportData? report;
  final String today;
  final List<String> mealTypes;
  final String selectedType;
  final String? selectedName;
  final String? selectedRecipe;
  final Map<String, List<MealReportMedia>> mediaByType;

  MealIndexResponse({
    required this.groups,
    this.currentGroup,
    required this.groupId,
    this.report,
    required this.today,
    required this.mealTypes,
    required this.selectedType,
    this.selectedName,
    this.selectedRecipe,
    required this.mediaByType,
  });

  factory MealIndexResponse.fromJson(Map<String, dynamic> json) {
    final mediaMap = <String, List<MealReportMedia>>{};
    if (json['media_by_type'] != null) {
      final Map<String, dynamic> mediaRaw = json['media_by_type'];
      mediaRaw.forEach((key, value) {
        if (value is List) {
          mediaMap[key] = value
              .map((e) => MealReportMedia.fromJson(e))
              .toList();
        }
      });
    }

    return MealIndexResponse(
      groups:
          (json['groups'] as List?)
              ?.map((e) => MealGroupData.fromJson(e))
              .toList() ??
          [],
      currentGroup: json['group'] != null
          ? MealGroupData.fromJson(json['group'])
          : null,
      groupId: json['group_id'] ?? 0,
      report: json['report'] != null
          ? MealReportData.fromJson(json['report'])
          : null,
      today: json['today'] ?? '',
      mealTypes:
          (json['meal_types'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      selectedType: json['selected_type'] ?? 'breakfast',
      selectedName: json['selected_name'],
      selectedRecipe: json['selected_recipe'],
      mediaByType: mediaMap,
    );
  }
}
