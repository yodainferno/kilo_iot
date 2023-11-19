import 'dart:convert';
import 'package:kilo_iot/core/error/exceptions.dart';
import 'package:kilo_iot/features/widgets/data/models/widgets_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WidgetsLocalStorageSource {
  Future<WidgetsListModel> getWidgets();

  Future<void> saveWidgets(WidgetsListModel widgetsToSave);
}

const LOCAL_STORAGE_KEY = 'widgets';

class WidgetsLocalStorageSourceImpl implements WidgetsLocalStorageSource {
  final SharedPreferences sharedPreferences;

  WidgetsLocalStorageSourceImpl({required this.sharedPreferences});

  @override
  Future<WidgetsListModel> getWidgets() {
    final String? jsonString = sharedPreferences.getString(LOCAL_STORAGE_KEY);
    if (jsonString != null) {
      return Future.value(WidgetsListModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveWidgets(WidgetsListModel widgetsToSave) {
    sharedPreferences.setString(
      LOCAL_STORAGE_KEY,
      json.encode(widgetsToSave.toJson())
    );
    return Future.value(null);
  }
}