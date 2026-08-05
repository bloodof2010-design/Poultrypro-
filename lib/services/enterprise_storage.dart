// name=lib/services/enterprise_storage.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enterprise.dart';

class EnterpriseStorage {
  // New key for enterprises storage (v1)
  static const String _storageKey = 'poultrypro_enterprises_v1';

  // Legacy keys that we check for migration (will not be deleted)
  // If you used a different key before, add it here for migration
  static const List<String> _legacyKeys = [
    'poultrypro_enterprises',
    'enterprises'
  ];

  // Load all enterprises. If no data exists under the new key,
  // attempt migration from legacy keys (without deleting legacy).
  static Future<List<Enterprise>> getAll() async {
    final prefs = await SharedPreferences.getInstance();

    // If new key exists, use it
    final encoded = prefs.getString(_storageKey);
    if (encoded != null && encoded.isNotEmpty) {
      try {
        return Enterprise.listFromJsonString(encoded);
      } catch (_) {
        // fallthrough to migration attempt
      }
    }

    // Migration: look for legacy keys and migrate if found
    for (final k in _legacyKeys) {
      final legacy = prefs.getString(k);
      if (legacy != null && legacy.isNotEmpty) {
        try {
          final list = Enterprise.listFromJsonString(legacy);
          // Save under new key (do not remove legacy key; we preserve old data)
          await prefs.setString(_storageKey, Enterprise.listToJsonString(list));
          return list;
        } catch (_) {
          // ignore and continue
        }
      }
    }

    // No data found: return empty
    return <Enterprise>[];
  }

  // Add enterprise and save
  static Future<void> addEnterprise(Enterprise ent) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getAll();
    list.insert(0, ent); // newest first
    await prefs.setString(_storageKey, Enterprise.listToJsonString(list));
  }

  // Get by id
  static Future<Enterprise?> getById(String id) async {
    final list = await getAll();
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // Replace all (not used by UI right now)
  static Future<void> saveAll(List<Enterprise> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, Enterprise.listToJsonString(list));
  }
}
