import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/key.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';

class UpdateBroker implements UseCase<void, UpdateParams> {
  final BrokerRepository repository;

  UpdateBroker(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, void>> call(UpdateParams params) async {
    return await repository.updateBroker(
      params.key,
      params.broker
    );
  }
}

class UpdateParams extends Equatable {
  final Key key;
  final BrokerEntity broker;
  const UpdateParams({required this.key, required this.broker});

  @override
  List<Object?> get props => [key, broker];
}