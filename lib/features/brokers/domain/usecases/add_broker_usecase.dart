import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';

class AddBroker implements UseCase<void, AddParams> {
  final BrokerRepository repository;

  AddBroker(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, void>> call(AddParams params) async {
    return await repository.addBroker(
      params.broker
    );
  }
}

class AddParams extends Equatable {
  final BrokerEntity broker;
  const AddParams(this.broker);
  
  @override
  List<Object?> get props => [broker];
}
