import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:kilo_iot/features/devices/presentation/pages/device_info/storages/device_info_form_state.dart';
import 'package:kilo_iot/features/devices/presentation/pages/devices_list/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class CrudDeviceWidget extends StatelessWidget {
  DevicesListStorage? devicesListStorage;
  DeviceInfoFormStorage? deviceFormStorage;

  EntityKey? brokerSavedKeyAfterDeleting; // ключ брокера - который используется для восстановления после удаления

  @override
  Widget build(BuildContext context) {
    devicesListStorage ??=
        Provider.of<DevicesListStorage>(context, listen: true);
    deviceFormStorage ??=
        Provider.of<DeviceInfoFormStorage>(context, listen: true);

    return Row(
      children: isBrokerExist()
          ? [
              Expanded(child: updateButtonWidget()),
              const SizedBox(width: 10.0),
              Expanded(child: deleteButtonWidget()),
            ]
          : [
              Expanded(child: addButtonWidget()),
            ],
    );
  }

  bool isBrokerExist() {
    return devicesListStorage?.currentDevice != null;
  }

  // if exist changingis - than not saved
  bool isEditButtonActive() {
    if (devicesListStorage == null ||
        devicesListStorage!.currentDevice == null) {
      return false;
    }

    return [
          devicesListStorage!.currentDevice!.topic,
          devicesListStorage!.currentDevice!.name,
          devicesListStorage!.currentDevice!.keys.join(' -> ')
        ].toString() !=
        [
          deviceFormStorage!.state['topic'],
          deviceFormStorage!.state['name'],
          deviceFormStorage!.state['keys'],
        ].toString();
  }

  Widget addButtonWidget() => buttonWidget(
        text: 'Добавить',
        onPressed: () async {
          if (devicesListStorage == null) return;

          Either<Failure, DeviceEntity> data =
              await devicesListStorage!.addDevice(
            brokerId: brokerSavedKeyAfterDeleting!,
            name: deviceFormStorage!.state['name'],
            keys: deviceFormStorage!.state['keys'].split(' -> '),
            topic: deviceFormStorage!.state['topic'],
          );

          data.fold(
            (l) {
              print(l.name);
              print(l.description);
            },
            (DeviceEntity device) {
              devicesListStorage?.setCurrentDevice(device);
            },
          );
        },
      );

  Widget updateButtonWidget() => buttonWidget(
        text: 'Обновить',
        onPressed: !isEditButtonActive()
            ? null
            : () async {
                if (devicesListStorage == null) return;

                Either<Failure, DeviceEntity> data =
                    await devicesListStorage!.updateDevice(
                  id: devicesListStorage!.currentDevice!.id,
                  brokerId: devicesListStorage!.currentDevice!.brokerId,
                  name: deviceFormStorage!.state['name'],
                  keys: deviceFormStorage!.state['keys'].split(' -> '),
                  topic: deviceFormStorage!.state['topic'],
                );

                data.fold(
                  (l) {
                    print(l.name);
                    print(l.description);
                  },
                  (DeviceEntity device) {
                    devicesListStorage?.setCurrentDevice(device);
                  },
                );
              },
      );

  Widget deleteButtonWidget() => buttonWidget(
        text: 'Удалить',
        buttonColor: Colors.red[900],
        onPressed: () async {
          if (devicesListStorage == null) return;

          Either<Failure, void> data = await devicesListStorage!.deleteDevice(
            id: devicesListStorage!.currentDevice!.id,
          );

          data.fold(
            (l) {
              print(l.name);
              print(l.description);
            },
            (_) {
              brokerSavedKeyAfterDeleting = devicesListStorage!.currentDevice!.brokerId;
              devicesListStorage?.setCurrentDevice(null);
            },
          );
        },
      );

  Widget buttonWidget(
      {required String text,
      required Future<void> Function()? onPressed,
      Color? buttonColor}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        backgroundColor: buttonColor,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
