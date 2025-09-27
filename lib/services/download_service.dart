import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/sound_item.dart';

class DownloadService {
  static DownloadService? _instance;
  static DownloadService get instance => _instance ??= DownloadService._();
  
  DownloadService._();

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need explicit storage permission for app documents
  }

  Future<String?> downloadSound(SoundItem soundItem, Function(double)? onProgress) async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      final response = await http.get(Uri.parse(soundItem.url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final soundsDirectory = Directory('${directory.path}/sounds');
        
        if (!await soundsDirectory.exists()) {
          await soundsDirectory.create(recursive: true);
        }

        final fileName = '${soundItem.id}_${soundItem.title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}.mp3';
        final filePath = '${soundsDirectory.path}/$fileName';
        final file = File(filePath);
        
        await file.writeAsBytes(bytes);
        return filePath;
      } else {
        throw Exception('Failed to download: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Download error: $e');
      return null;
    }
  }

  Future<List<String>> getDownloadedSounds() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final soundsDirectory = Directory('${directory.path}/sounds');
      
      if (!await soundsDirectory.exists()) {
        return [];
      }

      final files = await soundsDirectory.list().toList();
      return files
          .where((file) => file is File && file.path.endsWith('.mp3'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      debugPrint('Error getting downloaded sounds: $e');
      return [];
    }
  }

  Future<bool> deleteSound(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting sound: $e');
      return false;
    }
  }

  String getFileNameFromPath(String filePath) {
    return filePath.split('/').last.replaceAll('_', ' ').replaceAll('.mp3', '');
  }
}
