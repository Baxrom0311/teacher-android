import 'package:flutter/material.dart';
import '../../../data/repositories/ocr_repository.dart';

// Dummy implementation of ImagePicker
class ImagePicker {
  Future<dynamic> pickImage({required dynamic source}) async {
    // Simulator mock returning a fake path
    return null;
  }
}
enum ImageSource { camera, gallery }

class OcrGradesUiStub extends StatelessWidget {
  final OcrRepository ocrRepository;

  const OcrGradesUiStub({Key? key, required this.ocrRepository}) : super(key: key);

  Future<void> _scanPaper(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    
    // if image is not null -> show loading dialog
    // call ocrRepository.scanGradesFromImage(image.path)
    // auto-fill grades list from OcrResultModel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Baho qo\'yish')),
      body: const Center(child: Text('O\'quvchilar ro\'yxati...')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Kameradan skanerlash (OCR)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _scanPaper(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galereyadan tanlash'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _scanPaper(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.document_scanner),
        label: const Text('Qog\'ozni Skan qilish'),
      ),
    );
  }
}
