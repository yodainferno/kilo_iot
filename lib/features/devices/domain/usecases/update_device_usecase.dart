import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';
import 'package:kilo_iot/features/devices/domain/repository/device_repository.dart';

class UpdateDevice implements UseCase<void, UpdateParams> {
  final DevicesListRepository repository;

  UpdateDevice(this.repository);

  // callable class
  @override
  Future<Either<Failure, void>> call(UpdateParams params) async {
    List<DeviceEntity> devices = [...params.devicesList.devices];
    final index =
        devices.indexWhere((device) => device.id == params.updatedDevice.id);

    if (index == -1) return Left(Failure(name: 'Cant find device to update'));

    devices[index] = params.updatedDevice;
    return await repository.saveDevices(DevicesListEntity(devices));
  }
}

class UpdateParams extends Equatable {
  final DevicesListEntity devicesList;
  final DeviceEntity updatedDevice;
  const UpdateParams({required this.devicesList, required this.updatedDevice});

  @override
  List<Object?> get props => [devicesList, updatedDevice];
}
