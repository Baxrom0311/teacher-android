class SubjectData {
  final int id;
  final String name;
  final List<String> groups;
  final List<int> groupSubjectIds;

  SubjectData({
    required this.id,
    required this.name,
    required this.groups,
    required this.groupSubjectIds,
  });

  factory SubjectData.fromJson(Map<String, dynamic> json) {
    return SubjectData(
      id: json['id'],
      name: json['name'],
      groups: List<String>.from(json['groups'] ?? []),
      groupSubjectIds: List<int>.from(json['group_subject_ids'] ?? []),
    );
  }
}

class SubjectDetail {
  final int groupSubjectId;
  final int groupId;
  final String groupName;
  final List<TopicData> topics;

  SubjectDetail({
    required this.groupSubjectId,
    required this.groupId,
    required this.groupName,
    required this.topics,
  });

  factory SubjectDetail.fromJson(Map<String, dynamic> json) {
    return SubjectDetail(
      groupSubjectId: json['group_subject_id'],
      groupId: json['group_id'],
      groupName: json['group_name'],
      topics: (json['topics'] as List)
          .map((e) => TopicData.fromJson(e))
          .toList(),
    );
  }
}

class TopicData {
  final int id;
  final String title;
  final int? orderNo;
  final String? description;
  final List<TopicResource> resources;

  TopicData({
    required this.id,
    required this.title,
    this.orderNo,
    this.description,
    required this.resources,
  });

  factory TopicData.fromJson(Map<String, dynamic> json) {
    return TopicData(
      id: json['id'],
      title: json['title'],
      orderNo: json['order_no'],
      description: json['description'],
      resources: (json['resources'] as List)
          .map((e) => TopicResource.fromJson(e))
          .toList(),
    );
  }
}

class TopicResource {
  final int id;
  final String title;
  final String filePath;
  final String url;

  TopicResource({
    required this.id,
    required this.title,
    required this.filePath,
    required this.url,
  });

  factory TopicResource.fromJson(Map<String, dynamic> json) {
    return TopicResource(
      id: json['id'],
      title: json['title'],
      filePath: json['file_path'],
      url: json['url'],
    );
  }
}
