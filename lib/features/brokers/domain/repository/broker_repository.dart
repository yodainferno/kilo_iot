import 'package:dartz/dartz.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';

abstract class BrokersListRepository {
  Future<Either<Failure, BrokersListEntity>> getBrokers();
  Future<Either<Failure, void>> saveBrokers(BrokersListEntity brokers);
}
