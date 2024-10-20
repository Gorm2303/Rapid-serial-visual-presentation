import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class FileService {
  Future<String?> pickTextFile() async {
    try {
      // Allow only .txt and .docx extensions
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'docx', 'pdf'],  // Include PDF as an option
      );

      if (result != null && result.files.single.bytes != null) {
        Uint8List fileBytes = result.files.single.bytes!;
        String fileName = result.files.single.name.toLowerCase();

        // Determine the file type by checking the extension
        if (fileName.endsWith('.docx')) {
          return _handleDocx(fileBytes);  // Handle DOCX
        } else if (fileName.endsWith('.txt')) {
          // Handle TXT
          return String.fromCharCodes(fileBytes);
        } else if (fileName.endsWith('.pdf')) {
          // Handle PDF
          return 'PDF files are not supported yet';
        } else {
          return 'Unsupported file format';
        }
      }
      return null;
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  // DOCX Handling using the previous docxToText function
  String _handleDocx(Uint8List bytes) {
    final ZipDecoder zipDecoder = ZipDecoder();
    final archive = zipDecoder.decodeBytes(bytes);
    final List<String> textList = [];

    for (final file in archive) {
      // Extract the 'word/document.xml' part, which contains the actual text
      if (file.isFile && file.name == 'word/document.xml') {
        final fileContent = utf8.decode(file.content);
        final document = xml.XmlDocument.parse(fileContent);

        // Extract all <w:t> elements for text
        final paragraphNodes = document.findAllElements('w:t');
        for (final node in paragraphNodes) {
          textList.add(node.innerText);
        }
        break;  // We've found the main text content
      }
    }

    return textList.join('\n');
  }
}
