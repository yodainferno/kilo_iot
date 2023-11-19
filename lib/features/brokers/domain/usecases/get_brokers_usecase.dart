import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';

class GetBrokers implements UseCase<BrokersListEntity, NoParams> {
  final BrokersListRepository repository;

  GetBrokers(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, BrokersListEntity>> call(NoParams params) async {
    return await repository.getBrokers();
  }
}

class NoParams extends Equatable {
  const NoParams();
  
  @override
  List<Object?> get props => [];
}