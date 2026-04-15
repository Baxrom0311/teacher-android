import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/ocr_model.dart';
import 'base_repository.dart';

class OcrRepository extends BaseRepository {
  final DioClient _dioClient;

  OcrRepository(this._dioClient);

  /// Uploads an image of a grade sheet to parse and return a list of scores.
  Future<OcrResultModel> scanGradesFromImage(String imagePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
    });

    return safeCall<OcrResultModel>(
      () => _dioClient.dio.post(
        '/api/v1/ocr/scan-grades',
        data: formData,
      ),
      (data) => OcrResultModel.fromJson(data),
    );
  }
}
