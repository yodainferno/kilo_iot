import 'dart:convert';
import 'package:kilo_iot/core/error/exceptions.dart';
import 'package:kilo_iot/features/brokers/data/models/brokers_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BrokersLocalStorageSource {
  Future<BrokersListModel> getBrokers();

  Future<void> saveBrokers(BrokersListModel brokersToSave);
}

const LOCAL_STORAGE_KEY = 'brokers';

class BrokersLocalStorageSourceImpl implements BrokersLocalStorageSource {
  final SharedPreferences sharedPreferences;

  BrokersLocalStorageSourceImpl({required this.sharedPreferences});

  @override
  Future<BrokersListModel> getBrokers() {
    final String? jsonString = sharedPreferences.getString(LOCAL_STORAGE_KEY);
    if (jsonString != null) {
      return Future.value(BrokersListModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveBrokers(BrokersListModel brokersToSave) {
    sharedPreferences.setString(
      LOCAL_STORAGE_KEY,
      json.encode(brokersToSave.toJson())
    );
    return Future.value(null);
  }
}