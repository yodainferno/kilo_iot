import 'package:kilo_iot/data/brokers/models/brokers_model.dart';
import 'package:kilo_iot/domain/brokers/entities/brokers_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageDataSource {
  Future<BrokersEntity> getData();
  Future<bool> setData(BrokersEntity data);
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final String storageKey = 'brokers';
  SharedPreferences? preferences;

  getPreferences() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences;
  }

  @override
  Future<BrokersEntity> getData() async{
    SharedPreferences preferences = await getPreferences();

    return BrokersModel.fromJson(preferences.getString(storageKey) ?? '');
  }

  @override
  Future<bool> setData(BrokersEntity data) async{
    SharedPreferences preferences = await getPreferences();

    return preferences.setString(storageKey, BrokersModel.fromEntity(data).toJson());
  }
}