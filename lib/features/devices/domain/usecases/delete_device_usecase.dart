import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';
import 'package:kilo_iot/features/devices/domain/repository/device_repository.dart';

class DeleteDevice implements UseCase<void, DeleteParams> {
  final DevicesListRepository repository;

  DeleteDevice(this.repository);

  // callable class
  @override
  Future<Either<Failure, void>> call(DeleteParams params) async {
    return await repository.saveDevices(
      DevicesListEntity(
        params.devicesList.devices
            .where((device) => device.id != params.deleteId)
            .toList(),
      ),
    );
  }
}

class DeleteParams extends Equatable {
  final DevicesListEntity devicesList;
  final EntityKey deleteId;
  const DeleteParams({required this.devicesList, required this.deleteId});

  @override
  List<Object?> get props => [devicesList, deleteId];
}
