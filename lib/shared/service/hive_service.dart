import 'package:hive/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  /// Open a Hive box of a specific type, or return the opened box.
  Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  /// Generic set method (create or update).
  Future<void> set<T>(String boxName, String key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
  }

  /// Generic get method.
  Future<T?> get<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.get(key);
  }

  /// Generic delete method.
  Future<void> delete<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    await box.delete(key);
  }

  /// Generic update method (same as set, but explicit).
  Future<void> update<T>(String boxName, String key, T newValue) async {
    await set<T>(boxName, key, newValue);
  }

  /// Get all entries in the box as a Map<String, T>.
  Future<Map<String, T>> getAll<T>(String boxName) async {
    final box = await openBox<T>(
      boxName,
    ); // Use openBox instead of Hive.openBox here!
    final Map<String, T> allValues = {};
    for (var key in box.keys) {
      final value = box.get(key);
      if (value != null) {
        allValues[key.toString()] = value;
      }
    }
    return allValues;
  }

  /// Check if a key exists.
  Future<bool> exists<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.containsKey(key);
  }

  /// Clear all data in a box.
  Future<void> clear<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    await box.clear();
  }
}
