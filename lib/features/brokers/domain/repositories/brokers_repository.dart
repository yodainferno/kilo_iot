import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_entity.dart';


// определить откуда брать данные
// мы не знаем откуда (может бд, может интрнет, может localStorage)

abstract class BrokersRepository {
  Future<BrokersEntity> getBrokers();
  Future<BrokerEntity> addBroker(BrokerEntity broker);
  Future<bool> updateBroker(BrokerEntity broker);
  Future<bool> deleteBroker(BrokerEntity broker);
}
