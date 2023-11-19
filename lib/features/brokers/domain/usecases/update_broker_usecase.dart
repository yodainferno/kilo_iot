import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';

class UpdateBroker implements UseCase<void, UpdateParams> {
  final BrokersListRepository repository;

  UpdateBroker(this.repository);

  // callable class
  @override
  Future<Either<Failure, void>> call(UpdateParams params) async {
    List<BrokerEntity> brokers = [...params.brokersList.brokers];
    final index =
        brokers.indexWhere((broker) => broker.id == params.updatedBroker.id);

    if (index == -1) return Left(Failure(name: 'Cant find broker to update'));

    brokers[index] = params.updatedBroker;
    return await repository.saveBrokers(BrokersListEntity(brokers));
  }
}

class UpdateParams extends Equatable {
  final BrokersListEntity brokersList;
  final BrokerEntity updatedBroker;
  const UpdateParams({required this.brokersList, required this.updatedBroker});

  @override
  List<Object?> get props => [brokersList, updatedBroker];
}
