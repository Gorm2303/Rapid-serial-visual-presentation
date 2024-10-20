import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class FileService {
  Future<String?> pickTextFile() async {
    try {
      // Mobile/desktop implementation
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf', 'docx'],  // Specify your allowed extensions
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name.toLowerCase();

        // Check if it's a DOCX file
        if (fileName.endsWith('.docx')) {
          Uint8List bytes = await file.readAsBytes();
          return _handleDocx(bytes); // Handle DOCX
        } else if (fileName.endsWith('.txt')) {
          // Read and return TXT content
          return await file.readAsString();
        } else if (fileName.endsWith('.pdf')) {
          // Handle PDF
          return await _handlePdf(file);
        } else {
          return 'Unsupported file format';
        }
      }
      return null; // No file selected
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  Future<String?> _handlePdf(File file) async {
    try {
      PDFDoc doc = await PDFDoc.fromFile(file); // Use PDFDoc to read the PDF file
      return await doc.text; // Extract the text from the PDF
    } catch (e) {
      print('Error extracting text from PDF: $e');
      return null;
    }
  }

  // DOCX Handling similar to the web implementation
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
          textList.add(node.text);
        }
        break;  // We've found the main text content
      }
    }

    return textList.join('\n');
  }
}
