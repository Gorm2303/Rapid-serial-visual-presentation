import 'package:file_picker/file_picker.dart';
import 'dart:io'; // For File class

class FileService {
  Future<String?> pickTextFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        if (result.files.single.bytes != null) {
          // Web platform: Use `bytes`
          return String.fromCharCodes(result.files.single.bytes!);
        } else if (result.files.single.path != null) {
          // Mobile platform: Use `path` to read the file
          File file = File(result.files.single.path!);
          return await file.readAsString();
        }
      }
      return null; // No file selected
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }
}
