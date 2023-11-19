import 'package:equatable/equatable.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';

class DevicesListEntity extends Equatable {
  final List<DeviceEntity> devices;
  const DevicesListEntity(this.devices);

  @override
  List<Object?> get props => devices;
}
