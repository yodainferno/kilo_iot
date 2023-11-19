import 'dart:convert';
import 'package:kilo_iot/core/error/exceptions.dart';
import 'package:kilo_iot/features/devices/data/models/devices_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DevicesLocalStorageSource {
  Future<DevicesListModel> getDevices();

  Future<void> saveDevices(DevicesListModel devicesToSave);
}

const LOCAL_STORAGE_KEY = 'devices';

class DevicesLocalStorageSourceImpl implements DevicesLocalStorageSource {
  final SharedPreferences sharedPreferences;

  DevicesLocalStorageSourceImpl({required this.sharedPreferences});

  @override
  Future<DevicesListModel> getDevices() {
    final String? jsonString = sharedPreferences.getString(LOCAL_STORAGE_KEY);
    if (jsonString != null) {
      return Future.value(DevicesListModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveDevices(DevicesListModel devicesToSave) {
    sharedPreferences.setString(
      LOCAL_STORAGE_KEY,
      json.encode(devicesToSave.toJson())
    );
    return Future.value(null);
  }
}