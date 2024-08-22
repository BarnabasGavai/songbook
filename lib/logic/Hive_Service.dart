import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveService extends ChangeNotifier {
  Box mybox;
  Box? _box; // Nullable Box

  HiveService({required this.mybox}) {
    _box = mybox;
  }

  // Ensure the box is initialized before accessing
  Box _getBox() {
    if (_box == null) {
      throw StateError('Hive box is not initialized');
    }
    return _box!;
  }

  dynamic getItem(String key) {
    final box = _getBox();
    return box.get(key);
  }

  bool doesItExist(String key) {
    final box = _getBox();
    return box.containsKey(key);
  }

  Future<void> putItem(String key, dynamic value) async {
    final box = _getBox();
    await box.put(key, value);
    notifyListeners();
  }

  Future<void> deleteItem(String key) async {
    final box = _getBox();
    await box.delete(key);
    notifyListeners();
  }

  List<Map<dynamic, dynamic>> getAllItems() {
    final box = _getBox();
    return box.toMap().entries.map((e) {
      return e.value as Map<dynamic, dynamic>;
    }).toList();
  }

  @override
  void dispose() {
    _box?.close();
    super.dispose();
  }
}
