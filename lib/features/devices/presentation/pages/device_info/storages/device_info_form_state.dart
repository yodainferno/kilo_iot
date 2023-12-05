import 'package:flutter/material.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';

class DeviceInfoFormStorage extends ChangeNotifier {
  DeviceInfoFormStorage(DeviceEntity? device) {
    if (device != null) {
      // state['name'] = 'Лалала';
      state['keys'] = device.keys.join(' -> ');
      state['topic'] = device.topic;
    } else {
      // state['name'] = '';
      state['keys'] = '';
      state['topic'] = '';
    }
  }
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
    // 'name': 'Test broker',
    'keys': '',
    'topic': '',
  };
}
