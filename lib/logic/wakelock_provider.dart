import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WakelockProvider with ChangeNotifier {
  bool _isEnabled = false;

  void enableWakelock() {
    if (!_isEnabled) {
      WakelockPlus.enable();
      _isEnabled = true;
      notifyListeners();
    }
  }

  void disableWakelock() {
    if (_isEnabled) {
      WakelockPlus.disable();
      _isEnabled = false;
      notifyListeners();
    }
  }

  bool get isWakelockEnabled => _isEnabled;
}
