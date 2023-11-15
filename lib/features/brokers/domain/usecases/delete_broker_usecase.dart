import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/key.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/repository/broker_repository.dart';

class DeleteBroker implements UseCase<void, DeleteParams> {
  final BrokerRepository repository;

  DeleteBroker(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, void>> call(DeleteParams params) async {
    return await repository.deleteBroker(
      params.key
    );
  }
}

class DeleteParams extends Equatable {
  final Key key;
  const DeleteParams(this.key);
  
  @override
  List<Object?> get props => [key];
}