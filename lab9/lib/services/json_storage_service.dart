import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Service class for handling JSON file operations on local storage
class JsonStorageService {
  /// Get the application documents directory path
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Get a reference to a local file
  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  /// Read JSON data from a local file
  /// Returns an empty list if file doesn't exist
  static Future<List<Map<String, dynamic>>> readJsonFile(
    String fileName,
  ) async {
    try {
      final file = await _localFile(fileName);

      // Check if file exists
      if (!await file.exists()) {
        return [];
      }

      // Read file contents
      final contents = await file.readAsString();

      // Parse JSON
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error reading JSON file: $e');
      return [];
    }
  }

  /// Write JSON data to a local file
  static Future<bool> writeJsonFile(
    String fileName,
    List<Map<String, dynamic>> data,
  ) async {
    try {
      final file = await _localFile(fileName);

      // Convert to JSON string with formatting
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);

      // Write to file
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      print('Error writing JSON file: $e');
      return false;
    }
  }

  /// Check if a file exists
  static Future<bool> fileExists(String fileName) async {
    final file = await _localFile(fileName);
    return file.exists();
  }

  /// Delete a file
  static Future<bool> deleteFile(String fileName) async {
    try {
      final file = await _localFile(fileName);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
}
