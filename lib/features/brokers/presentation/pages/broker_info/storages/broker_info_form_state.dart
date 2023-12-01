import 'package:flutter/material.dart';

class BrokerFormStorage extends ChangeNotifier {
  String getFieldState(String key) {
    return state[key] ?? '';
  }

  void setFieldState(String key, String newValue) {
    if (state.containsKey(key)) {
      state[key] = newValue;
      notifyListeners();
    }
  }

  final Map<String, dynamic> state = {
    'name': '',
    'address': '',
    'port': '',
  };
}