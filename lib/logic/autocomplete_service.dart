import 'package:flutter/material.dart';

class AutoCOmpleteState with ChangeNotifier {
  String _text = '';

  String get text => _text;

  void setText(String newText) {
    _text = newText;
    notifyListeners();
  }

  void clearText() {
    _text = '';
    notifyListeners();
  }
}
