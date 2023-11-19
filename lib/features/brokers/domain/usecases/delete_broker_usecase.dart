import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';

class DeleteBroker implements UseCase<void, DeleteParams> {
  final BrokersListRepository repository;

  DeleteBroker(this.repository);

  // callable class
  @override
  Future<Either<Failure, void>> call(DeleteParams params) async {
    return await repository.saveBrokers(
      BrokersListEntity(
        params.brokersList.brokers
            .where((broker) => broker.id != params.deleteId)
            .toList(),
      ),
    );
  }
}

class DeleteParams extends Equatable {
  final BrokersListEntity brokersList;
  final EntityKey deleteId;
  const DeleteParams({required this.brokersList, required this.deleteId});

  @override
  List<Object?> get props => [brokersList, deleteId];
}
