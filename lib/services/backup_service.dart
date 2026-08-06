import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enterprise.dart';
import '../models/inventory_item.dart';
import 'storage_service.dart';

class BackupService {
  static const String _enterpriseKey = 'poultrypro_enterprises_v1';
  static const String _inventoryKey = 'inventory_items';

  // Helper to choose Downloads folder (Android) or fallback
  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/Download');
      if (await dir.exists()) return dir;
      final ext = await getExternalStorageDirectory();
      if (ext != null) return ext;
      return await getApplicationDocumentsDirectory();
    } else {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) return downloads;
      return await getApplicationDocumentsDirectory();
    }
  }

  static Future<String> exportData() async {
    final enterprises = await StorageService.getEnterprises();
    final inventory = await StorageService.getInventoryItems();

    final Map<String, dynamic> out = {
      'enterprises': enterprises.map((e) => e.toJson()).toList(),
      'inventory_items': inventory.map((i) => i.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };

    final String encoded = const JsonEncoder.withIndent('  ').convert(out);

    final dir = await _getDownloadDirectory();
    final now = DateTime.now();
    final filename = 'poultrypro_backup_${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.json';
    final file = File('${dir.path}/$filename');

    await file.writeAsString(encoded);
    return file.path;
  }

  static Future<void> importData() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      throw Exception('No file selected');
    }

    final path = result.files.single.path;
    if (path == null) throw Exception('Invalid file path');

    final file = File(path);
    final content = await file.readAsString();
    final Map<String, dynamic> decoded = json.decode(content) as Map<String, dynamic>;

    if (!decoded.containsKey('enterprises') || !decoded.containsKey('inventory_items')) {
      throw Exception('Invalid backup file format');
    }

    final List<dynamic> entRaw = decoded['enterprises'] as List<dynamic>;
    final List<dynamic> invRaw = decoded['inventory_items'] as List<dynamic>;

    final enterprises = entRaw.map((e) => Enterprise.fromJson(e as Map<String, dynamic>)).toList();
    final inventory = invRaw.map((i) => InventoryItem.fromJson(i as Map<String, dynamic>)).toList();

    // Overwrite both SharedPreferences keys (per requirements)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_enterpriseKey, Enterprise.listToJsonString(enterprises));
    await prefs.setString(_inventoryKey, InventoryItem.listToJsonString(inventory));
  }
}
