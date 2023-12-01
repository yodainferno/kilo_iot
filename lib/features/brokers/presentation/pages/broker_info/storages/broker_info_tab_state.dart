import 'package:flutter/material.dart';

class TabStorage extends ChangeNotifier {
  int get tab => _tab;

  set tab(newValue) {
    if (_tab == newValue) return;
    
    _tab = newValue;
    notifyListeners();
  }

  int _tab = 0;
}
