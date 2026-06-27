import 'package:hive_flutter/hive_flutter.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';

class LocalStorageService {
  LocalStorageService._();

  static Box<dynamic>? _appBox;
  static final Map<String, dynamic> _memoryStore = <String, dynamic>{};

  static Future<void> initialize() async {
    await Hive.initFlutter();
    _appBox = await Hive.openBox<dynamic>(StorageKeys.appBox);
  }

  static bool get isInitialized => _appBox != null;

  static Future<void> writeValue(String key, dynamic value) async {
    if (!isInitialized) {
      _memoryStore[key] = value;
      return;
    }
    await _appBox!.put(key, value);
  }

  static T? readValue<T>(String key) {
    if (!isInitialized) {
      return _memoryStore[key] as T?;
    }
    return _appBox!.get(key) as T?;
  }

  static Future<void> deleteValue(String key) async {
    if (!isInitialized) {
      _memoryStore.remove(key);
      return;
    }
    await _appBox!.delete(key);
  }
}
