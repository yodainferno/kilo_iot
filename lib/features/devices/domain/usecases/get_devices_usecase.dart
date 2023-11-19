import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';
import 'package:kilo_iot/features/devices/domain/repository/device_repository.dart';

class GetDevices implements UseCase<DevicesListEntity, NoParams> {
  final DevicesListRepository repository;

  GetDevices(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, DevicesListEntity>> call(NoParams params) async {
    return await repository.getDevices();
  }
}

class NoParams extends Equatable {
  const NoParams();
  
  @override
  List<Object?> get props => [];
}