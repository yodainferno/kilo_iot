import 'package:kilo_iot/features/devices/data/models/device_model.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';

class DevicesListModel extends DevicesListEntity {
  late final List<DeviceEntity> devices;

  DevicesListModel(this.devices) : super(devices);

  DevicesListModel.fromEntity(DevicesListEntity entity) : super(entity.devices) {
    devices = entity.devices;
  }

  List<Map<String, dynamic>> toJson() {
    return devices.map((device) => DeviceModel.fromEntity(device).toJson()).toList();
  }

  factory DevicesListModel.fromJson(List<dynamic> json) {
    List<Map<String, dynamic>> jsonTyped = json.map((element) => element as Map<String, dynamic>).toList();
    final List<DeviceModel> devicesList =
        jsonTyped.map((Map<String, dynamic> deviceJson) => DeviceModel.fromJson(deviceJson)).toList();

    return DevicesListModel(devicesList);
  }
}
