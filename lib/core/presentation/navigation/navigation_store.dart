import 'package:flutter/material.dart';

class NavigationStore extends ChangeNotifier {
  String _page = '';
  String get page => _page;

  set page(String page) {
    _page = page;
    notifyListeners();
  }
}
