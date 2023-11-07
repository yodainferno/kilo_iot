
import 'package:kilo_iot/domain/brokers/entities/brokers_entity.dart';

// определить откуда брать данные
// мы не знаем откуда (может бд, может интрнет, может localStorage)
abstract class BrokersRepository {
  Future<BrokersEntity> getBrokers();
  Future<bool> setBrokers(BrokersEntity brokers);
}
