import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';

class AddBroker implements UseCase<void, AddParams> {
  final BrokersListRepository repository;

  AddBroker(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, void>> call(AddParams params) async {
    return await repository.saveBrokers(
      BrokersListEntity([ // добавляем в начало
        params.newBroker,
        ...params.brokersList.brokers,
      ])
    );
  }
}

class AddParams extends Equatable {
  final BrokersListEntity brokersList;
  final BrokerEntity newBroker;
  const AddParams({required this.brokersList, required this.newBroker});
  
  @override
  List<Object?> get props => [brokersList, newBroker];
}
