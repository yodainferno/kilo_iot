import 'package:dartz/dartz.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';

abstract class DevicesListRepository {
  Future<Either<Failure, DevicesListEntity>> getDevices();
  Future<Either<Failure, void>> saveDevices(DevicesListEntity devices);
}
