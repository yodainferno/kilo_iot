import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/mqtt_data_source.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/broker_info/storages/mqtt_connection_state.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:kilo_iot/features/devices/presentation/pages/device_info/device_page.dart';
import 'package:kilo_iot/features/devices/presentation/pages/devices_list/storages/brokers_list_storage.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';

class DevicesListPage extends StatefulWidget {
  const DevicesListPage({super.key});

  @override
  State<DevicesListPage> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends State<DevicesListPage> {
  connect(MqttConnectionStorage mqttConnectionStorage) async {
    print('1231232');
    mqttConnectionStorage.mqttConnection = MQTTConnection(
      address: 'mqtt.34devs.ru',
      port: 1883,
    );
    await mqttConnectionStorage.connect();
    mqttConnectionStorage.mqttConnection?.listenTopics(
      callBack: (MqttReceivedMessage<MqttMessage?> data) {
        print(data.topic);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MqttConnectionStorage mqttConnectionStorage =
        Provider.of<MqttConnectionStorage>(context, listen: true);

    if (mqttConnectionStorage.mqttConnection?.isConnected != true) {
      connect(mqttConnectionStorage);
    }

    final DevicesListStorage devicesListStorage =
        Provider.of<DevicesListStorage>(context, listen: true);

    final List<DeviceEntity> devicesList = devicesListStorage.devices.devices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(
        //       //     builder: (context) => const BrokerInfoPage(),
        //       //   ),
        //       // );
        //     },
        //     icon: const Icon(Icons.add),
        //   ),
        // ],
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
              children: [
                ...List.generate(
                  devicesList.length,
                  (index) {
                    DeviceEntity device = devicesList[index];

                    return GestureDetector(
                      child: InformationBlock(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Keys: ${device.keys.join(' -> ')}",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text(
                              "Topic: ${device.topic}",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              "${device.id.key}",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              "broker: ${device.brokerId.key}",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14.0,
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
                ),
                // ...List.generate(devicesList.length, (index) {
                //   DeviceEntity device = devicesList[index];
                //   return Row(
                //     children: [
                //       Container(
                //         child: Text(
                //             "${device.brokerId.key} - ${device.keys} ${device.topic}"),
                //       ),
                //       ElevatedButton(
                //         onPressed: () {
                //           devicesListStorage.deleteDevice(
                //             id: device.id,
                //           );
                //         },
                //         child: Text('delete'),
                //       ),
                //       ElevatedButton(
                //         onPressed: () {
                //           devicesListStorage.updateDevice(
                //             id: device.id,
                //             brokerId: EntityKey(key: 'id-4444'),
                //             keys: ['hydra', 'data'],
                //             topic: 'kitchen',
                //           );
                //         },
                //         child: Text('update'),
                //       ),
                //     ],
                //   );
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
