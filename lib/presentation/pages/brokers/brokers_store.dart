import 'package:flutter/material.dart';
import 'package:kilo_iot/data/brokers/repositories/brokers_repository_impl.dart';
import 'package:kilo_iot/data/data_sources/local_storage_data_source.dart';
import 'package:kilo_iot/domain/brokers/entities/broker_entity.dart';
import 'package:kilo_iot/domain/brokers/brokers_repository.dart';
import 'package:kilo_iot/domain/base/foreign_key.dart';
import 'package:kilo_iot/domain/brokers/entities/brokers_entity.dart';


// хранилище - управляет экземпляром BrokersRepository
// добавлять / удалять / менять данные
class BrokersStore extends ChangeNotifier {
  // repository - to get ans set
  BrokersRepository brokersRepository = BrokersRepositoryImpl(localStorageSource: LocalStorageDataSourceImpl());
  
  BrokersEntity data = BrokersEntity(brokers: []);

  BrokersStore() {
    getBrokers();
  }

  void getBrokers() async {
    data = await brokersRepository.getBrokers();
    notifyListeners();
  }
  void addBroker(BrokerEntity newItem) {
    data.brokers = [newItem, ...data.brokers];
    brokersRepository.setBrokers(data);
    notifyListeners();
  }
  void deleteBroker(ForeignKey brokerKey) {
    final int index = data.brokers.indexWhere((item) => item.id == brokerKey);
    if (index != -1) {
      data.brokers.removeAt(index);
      brokersRepository.setBrokers(data);
      notifyListeners();
    }
  }
  void updateBroker(BrokerEntity newItem) {
    final int index = data.brokers.indexWhere((item) => item.id == newItem.id);
    if (index != -1) {
      data.brokers[index] = newItem;
      brokersRepository.setBrokers(data);
      notifyListeners();
    }
  }
}
