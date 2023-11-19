import 'package:dartz/dartz.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/data/datasource/brokers_local_storage_source.dart';
import 'package:kilo_iot/features/brokers/data/models/brokers_list_model.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';

class BrokersListRepositoryImpl implements BrokersListRepository {
  final BrokersLocalStorageSource localStorageSource;

  BrokersListRepositoryImpl({
    required this.localStorageSource
  });

  @override
  Future<Either<Failure, BrokersListEntity>> getBrokers() async{
    try {
      return Right(await localStorageSource.getBrokers());
    } catch(error) {
      return Left(Failure(name: 'Error in getting brokers', description: error.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> saveBrokers(BrokersListEntity brokers) async {
    BrokersListModel brokersModel = BrokersListModel.fromEntity(brokers);
    try {
      return Right(await localStorageSource.saveBrokers(brokersModel));
    } catch(error) {
      return Left(Failure(name: 'Error in getting brokers', description: error.toString()));
    }
  }
}
