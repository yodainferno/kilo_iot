import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/devices/data/datasource/devices_local_storage_source.dart';
import 'package:kilo_iot/features/devices/data/repositories/broker_repository_impl.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:kilo_iot/features/devices/domain/entities/devices_list_entity.dart';
import 'package:kilo_iot/features/devices/domain/usecases/add_device_usecase.dart';
import 'package:kilo_iot/features/devices/domain/usecases/delete_device_usecase.dart';
import 'package:kilo_iot/features/devices/domain/usecases/get_devices_usecase.dart';
import 'package:kilo_iot/features/devices/domain/usecases/update_device_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicesListStorage extends ChangeNotifier {
  DevicesListEntity devices = const DevicesListEntity([]);

  GetDevices? getDevicesUsecase;
  AddDevice? addDeviceUsecase;
  DeleteDevice? deleteDeviceUsecase;
  UpdateDevice? updateDeviceUsecase;

  DevicesListStorage() {
    initUsecases().then((value) {
      getDevices();
    });
  }

  Future<void> initUsecases() async {
    final sharedPreferencesInstance = await SharedPreferences.getInstance();
    final repositoryInstance = DevicesListRepositoryImpl(
      localStorageSource: DevicesLocalStorageSourceImpl(
        sharedPreferences: sharedPreferencesInstance,
      ),
    );

    getDevicesUsecase = GetDevices(repositoryInstance);
    addDeviceUsecase = AddDevice(repositoryInstance);
    deleteDeviceUsecase = DeleteDevice(repositoryInstance);
    updateDeviceUsecase = UpdateDevice(repositoryInstance);
  }

  void getDevices() async {
    assert(getDevicesUsecase != null);

    Either<Failure, DevicesListEntity> data =
        await getDevicesUsecase!(const NoParams());

    data.fold((Failure failure) {
      // erorr
      print('get');
      print(failure.name);
      print(failure.description);

    }, (DevicesListEntity data) async {
      devices = data;
      notifyListeners();
    });
  }

  void addDevice({
    required EntityKey brokerId,
    required List<String> keys,
    required String topic,
  }) async {
    assert(addDeviceUsecase != null);

    DeviceEntity? device;
    // try {
      assert(topic.isNotEmpty);
      device =
          DeviceEntity.create(brokerId: brokerId, keys: keys, topic: topic);
    // } catch (_) {
    //   //
    //   return;
    // }

    Either<Failure, void> data = await addDeviceUsecase!(AddParams(
      devicesList: devices,
      newDevice: device,
    ));

    data.fold((Failure failure) {
      // erorr
      print('addd');
      print(failure.name);
      print(failure.description);
    }, (_) async {
      print('hahahaha');
      getDevices();
    });
  }

  void deleteDevice({
    required EntityKey id,
  }) async {
    assert(deleteDeviceUsecase != null);

    Either<Failure, void> data = await deleteDeviceUsecase!(DeleteParams(
      devicesList: devices,
      deleteId: id,
    ));

    data.fold((Failure failure) {
      // erorr
      print('delete');
      print(failure.name);
      print(failure.description);
    }, (_) async {
      getDevices();
    });
  }

  void updateDevice({
    required EntityKey id,
    required EntityKey brokerId,
    required List<String> keys,
    required String topic,
  }) async {
    assert(updateDeviceUsecase != null);

    DeviceEntity? device;
    try {
      assert(topic.isNotEmpty);
      device = DeviceEntity.withId(
          id: id, brokerId: brokerId, keys: keys, topic: topic);
    } catch (_) {
      //
      return;
    }

    Either<Failure, void> data = await updateDeviceUsecase!(UpdateParams(
      devicesList: devices,
      updatedDevice: device,
    ));

    data.fold((Failure failure) {
      // erorr
      print('update');
      print(failure.name);
      print(failure.description);
    }, (_) async {
      getDevices();
    });
  }
}
