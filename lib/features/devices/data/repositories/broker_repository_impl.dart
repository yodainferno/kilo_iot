import 'package:dartz/dartz.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/devices/data/datasource/devices_local_storage_source.dart';
import 'package:kilo_iot/features/devices/data/models/devices_list_model.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';
import 'package:kilo_iot/features/devices/domain/repository/device_repository.dart';

class DevicesListRepositoryImpl implements DevicesListRepository {
  final DevicesLocalStorageSource localStorageSource;

  DevicesListRepositoryImpl({
    required this.localStorageSource
  });

  @override
  Future<Either<Failure, DevicesListEntity>> getDevices() async{
    try {
      return Right(await localStorageSource.getDevices());
    } catch(error) {
      return Left(Failure(name: 'Error in getting devices', description: error.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> saveDevices(DevicesListEntity devices) async {
    DevicesListModel devicesModel = DevicesListModel.fromEntity(devices);
    try {
      return Right(await localStorageSource.saveDevices(devicesModel));
    } catch(error) {
      return Left(Failure(name: 'Error in getting devices', description: error.toString()));
    }
  }
}
