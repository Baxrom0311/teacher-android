class OcrResultModel {
  final String message;
  final String rawText;
  final String engine;
  final List<OcrExtractedItem> extractedData;

  OcrResultModel({
    required this.message,
    required this.rawText,
    required this.engine,
    required this.extractedData,
  });

  factory OcrResultModel.fromJson(Map<String, dynamic> json) {
    return OcrResultModel(
      message: json['message'] ?? '',
      rawText: json['raw_text'] ?? '',
      engine: json['engine'] ?? '',
      extractedData: (json['extracted_data'] as List? ?? [])
          .map((e) => OcrExtractedItem.fromJson(e))
          .toList(),
    );
  }
}

class OcrExtractedItem {
  final String studentName;
  final String score;
  final double confidence;

  OcrExtractedItem({
    required this.studentName,
    required this.score,
    required this.confidence,
  });

  factory OcrExtractedItem.fromJson(Map<String, dynamic> json) {
    return OcrExtractedItem(
      studentName: json['student_name'] ?? '',
      score: json['score'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
