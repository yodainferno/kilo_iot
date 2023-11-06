import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/domain/devices/device_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DevicesDataInt {
  String add(DeviceData newDevice);
  void update(String id, DeviceData device);
  void delete(String id);
  void clear();

  Future syncToStore();
  Future syncFromStore();

  // void fromJson(String jsonString);
  String toJson();
}

class DevicesData extends ChangeNotifier implements DevicesDataInt {
  Map<String, DeviceData> devices = {};
  DevicesData() {
    syncFromStore();
  }

  fromJson(String jsonString) {
    try {
      Map<String, dynamic> data = jsonDecode(jsonString);
      devices = data.map((key, value) {
        DeviceData deviceData = DeviceData();
        deviceData.fromJson(utf8.decode(base64.decode(value)));
        return MapEntry(key, deviceData);
      });
    } catch (_) {
      devices = {};
    }
  }

  @override
  String toJson() {
    final data = devices.map((key, value) {
      return MapEntry(key, base64.encode(utf8.encode(value.toJson())));
    });
    return jsonEncode(data);
  }

  @override
  String add(DeviceData newDevice) {
    final String id = _generateMd5(DateTime.now().toString());
    devices = {
      id: newDevice,
      ...devices
    };

    notifyListeners();
    syncToStore();

    return id;
  }

  @override
  void update(String id, DeviceData device) {
    devices[id] = device;
    notifyListeners();
    syncToStore();
  }

  @override
  void delete(String id) {
    devices.remove(id);
    notifyListeners();
    syncToStore();
  }

  @override
  void clear() {
    devices.clear();
    notifyListeners();
    syncToStore();
  }

  @override
  Future syncToStore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('devices', toJson());
  }

  @override
  Future syncFromStore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    fromJson(preferences.getString('devices') ?? '{}');
    notifyListeners();
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
