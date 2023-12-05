import 'package:flutter/material.dart';
import 'package:kilo_iot/core/helpers/mqtt_widget_connection.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:kilo_iot/features/devices/presentation/pages/device_info/device_page.dart';
import 'package:kilo_iot/features/devices/presentation/pages/devices_list/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class DevicesListPage extends StatefulWidget {
  const DevicesListPage({super.key});

  @override
  State<DevicesListPage> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends State<DevicesListPage> {
  dynamic getDataByKeys(Map object, List<String> keys) {
    if (keys.isEmpty || object.isEmpty) return null;

    final data = object[keys[0]];
    if (data is Map) {
      return getDataByKeys(data, keys.sublist(1));
    } else {
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DevicesListStorage devicesListStorage =
        Provider.of<DevicesListStorage>(context, listen: true);

    final List<DeviceEntity> devicesList = devicesListStorage.devices.devices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Списко датчиков'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 15.0,
            ),
            child: Wrap(
              runSpacing: 20,
              children: devicesList.isEmpty
                  ? [
                      noDataWidget(),
                    ]
                  : devicesListWidget(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget noDataWidget() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Вы еще не добавили ни одного датчика',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  List<Widget> devicesListWidget(BuildContext context) {
    final DevicesListStorage devicesListStorage =
        Provider.of<DevicesListStorage>(context, listen: true);

    MqttWidgetConnection mqttWidgetConnection =
        Provider.of<MqttWidgetConnection>(context, listen: true);

    final List<DeviceEntity> devicesList = devicesListStorage.devices.devices;

    return List.generate(
      devicesList.length,
      (index) {
        DeviceEntity device = devicesList[index];

        return GestureDetector(
          child: InformationBlock(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  mqttWidgetConnection.getDataByTopicKeys(
                      device.topic, device.keys),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            devicesListStorage.setCurrentDevice(device);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DeviceInfoPage(),
              ),
            );
          },
        );
      },
    );
  }
}
