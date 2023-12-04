import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';


class GetBrokerById implements UseCase<BrokerEntity, FindParams> {
  final BrokersListRepository repository;

  GetBrokerById(this.repository);

  // callable class
  @override
  Future<Either<Failure, BrokerEntity>> call(FindParams params) async {
    final data = await repository.getBrokers();
    return data.fold((Failure failure) {
      // erorr
      return Left(failure);
    }, (BrokersListEntity brokersData) {
      int foundEntity = brokersData.brokers
          .indexWhere((broker) => broker.id == params.findId);
      if (foundEntity == -1) {
        return Left(Failure(name: 'Cant find item'));
      }
      return Right(brokersData.brokers[foundEntity]);
    });
  }
}

class FindParams extends Equatable {
  final EntityKey findId;
  const FindParams({required this.findId});

  @override
  List<Object?> get props => [findId];
}
