import 'package:dartz/dartz.dart';
import 'package:kilo_iot/core/domain/key.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';

abstract class BrokerRepository {
  Future<Either<Failure, BrokersListEntity>> getBrokers();
  Future<Either<Failure, void>> addBroker(BrokerEntity broker);
  Future<Either<Failure, void>> updateBroker(Key key, BrokerEntity broker);
  Future<Either<Failure, void>> deleteBroker(Key key);
}
