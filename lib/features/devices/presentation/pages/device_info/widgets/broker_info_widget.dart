import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kilo_iot/core/presentation/base_components/input_widget.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
import 'package:kilo_iot/features/devices/presentation/pages/devices_list/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class BrokerInfoWidget extends StatefulWidget {
  const BrokerInfoWidget({super.key});

  @override
  State<BrokerInfoWidget> createState() => _BrokerInfoWidgetState();
}

class _BrokerInfoWidgetState extends State<BrokerInfoWidget> {
  BrokerEntity? brokerData;

  void getBroker(BuildContext context) async {
    final DevicesListStorage devicesListStorage =
        Provider.of<DevicesListStorage>(context, listen: false);
    final BrokersListStorage brokersListStorage =
        Provider.of<BrokersListStorage>(context, listen: false);

    await Future.delayed(const Duration(milliseconds: 0));

    final brokerDataRaw = await brokersListStorage
        .getBrokerById(devicesListStorage.currentDevice!.brokerId);

    if (brokerDataRaw != null) {
      setState(() {
        brokerData = brokerDataRaw;
      });
    }
  }

  final Map<String, Map<String, String?>> formFields = {
    // 'name': {'label': 'Название брокера'},
    'address': {'label': 'Адрес сервера-брокера'},
    'port': {'label': 'Порт сервера-брокера'},
  };

  @override
  Widget build(BuildContext context) {
    if (brokerData == null) {
      getBroker(context);
    }
    return Wrap(
      runSpacing: 20,
      children: [
        InputWidget(
          initialValue: brokerData?.url,
          disabled: true,
          label: formFields['address']!['label'],
        ),
        InputWidget(
          initialValue: brokerData?.port.toString(),
          disabled: true,
          label: formFields['port']!['label'],
        ),
      ],
    );
  }
}
