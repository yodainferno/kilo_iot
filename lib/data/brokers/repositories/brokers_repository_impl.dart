
import 'package:kilo_iot/data/data_sources/local_storage_data_source.dart';
import 'package:kilo_iot/domain/brokers/brokers_repository.dart';
import 'package:kilo_iot/domain/brokers/entities/brokers_entity.dart';

// определить откуда брать данные
// тут выбор один - из local storage
// реализация
class BrokersRepositoryImpl implements BrokersRepository {
  final LocalStorageDataSource localStorageSource;

  BrokersRepositoryImpl({required this.localStorageSource});

  @override
  Future<BrokersEntity> getBrokers () async{
    return localStorageSource.getData();
  }

  @override
  Future<bool> setBrokers(BrokersEntity brokers) {
    return localStorageSource.setData(brokers);
  }
}
