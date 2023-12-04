import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_form_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/broker_info_tab_state.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/form_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/messages_list_widget.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/widgets/mqtt_connection_indicator.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class BrokerInfoPageView extends StatelessWidget {
  // tab controller
  TabStorage? tabStorage;
  final PageController tabController = PageController(initialPage: 0);

  void _initTabControllerOnChanged(BuildContext context) {
    tabStorage = Provider.of<TabStorage>(context, listen: false);
    tabController.addListener(
      () => {
        if (tabController.hasClients && tabController.page != null)
          {tabStorage!.tab = tabController.page!.round()}
      },
    );
  }

  void dispose() {
    return tabController.dispose();
  }

  Widget build(BuildContext context) {
    if (tabStorage == null) {
      _initTabControllerOnChanged(context);
    }
    return PageView(
      controller: tabController,
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  left: 15.0,
                  right: 15.0,
                  bottom: 60.0
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          InformationBlock(
                            child: BrokerFormWidget(),
                          ),
                          const SizedBox(height: 15.0),
                          CrudWidget(),
                        ],
                      ),
                    ),
                    MqttConnectionIndicator(),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 15.0,
          ),
          child: MessagesListWidget(),
        ),
      ],
    );
  }
}

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
          brokersListStorage!.currentBroker!.url,
          brokersListStorage!.currentBroker!.port.toString()
        ].toString() !=
        [brokerFormStorage!.state['address'], brokerFormStorage!.state['port']]
            .toString();
  }

  Widget addButtonWidget() => buttonWidget(
        text: 'Добавить',
        onPressed: () async {
          if (brokersListStorage == null) return;

          Either<Failure, BrokerEntity> data =
              await brokersListStorage!.addBroker(
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
