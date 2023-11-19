import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';
import 'package:kilo_iot/features/devices/domain/repository/device_repository.dart';

class AddDevice implements UseCase<void, AddParams> {
  final DevicesListRepository repository;

  AddDevice(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, void>> call(AddParams params) async {
    return await repository.saveDevices(
      DevicesListEntity([ // добавляем в начало
        params.newDevice,
        ...params.devicesList.devices,
      ])
    );
  }
}

class AddParams extends Equatable {
  final DevicesListEntity devicesList;
  final DeviceEntity newDevice;
  const AddParams({required this.devicesList, required this.newDevice});
  
  @override
  List<Object?> get props => [devicesList, newDevice];
}
