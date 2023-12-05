import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_form_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class CrudWidget extends StatelessWidget {
  BrokersListStorage? brokersListStorage;
  BrokerFormStorage? brokerFormStorage;

  @override
  Widget build(BuildContext context) {
    brokersListStorage ??=
        Provider.of<BrokersListStorage>(context, listen: true);
    brokerFormStorage ??= Provider.of<BrokerFormStorage>(context, listen: true);

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
    return brokersListStorage?.currentBroker != null;
  }

  // if exist changingis - than not saved
  bool isEditButtonActive() {
    if (brokersListStorage == null ||
        brokersListStorage!.currentBroker == null) {
      return false;
    }

    return [
          brokersListStorage!.currentBroker!.name,
          brokersListStorage!.currentBroker!.url,
          brokersListStorage!.currentBroker!.port.toString()
        ].toString() !=
        [
          brokerFormStorage!.state['name'],
          brokerFormStorage!.state['address'],
          brokerFormStorage!.state['port']
        ].toString();
  }

  Widget addButtonWidget() => buttonWidget(
        text: 'Добавить',
        onPressed: () async {
          if (brokersListStorage == null) return;

          Either<Failure, BrokerEntity> data =
              await brokersListStorage!.addBroker(
            name: brokerFormStorage!.state['name'],
            url: brokerFormStorage!.state['address'],
            port: brokerFormStorage!.state['port'],
          );

          data.fold(
            (l) {
              print(l.name);
              print(l.description);
            },
            (BrokerEntity broker) {
              brokersListStorage?.setCurrentBroker(broker);
              brokerFormStorage!.setFieldState('name', broker.name);
            },
          );
        },
      );

  Widget updateButtonWidget() => buttonWidget(
        text: 'Обновить',
        onPressed: !isEditButtonActive()
            ? null
            : () async {
                if (brokersListStorage == null) return;

                Either<Failure, BrokerEntity> data =
                    await brokersListStorage!.updateBroker(
                  id: brokersListStorage!.currentBroker!.id,
                  name: brokerFormStorage!.state['name'],
                  url: brokerFormStorage!.state['address'],
                  port: brokerFormStorage!.state['port'],
                );

                data.fold(
                  (l) {
                    print(l.name);
                    print(l.description);
                  },
                  (BrokerEntity broker) {
                    brokersListStorage?.setCurrentBroker(broker);
                    brokerFormStorage!.setFieldState('name', broker.name);
                  },
                );
              },
      );

  Widget deleteButtonWidget() => buttonWidget(
        text: 'Удалить',
        buttonColor: Colors.red[900],
        onPressed: () async {
          if (brokersListStorage == null) return;

          Either<Failure, void> data = await brokersListStorage!.deleteBroker(
            id: brokersListStorage!.currentBroker!.id,
          );

          data.fold(
            (l) {
              print(l.name);
              print(l.description);
            },
            (_) {
              brokersListStorage?.setCurrentBroker(null);
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
