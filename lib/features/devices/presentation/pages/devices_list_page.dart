import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';
import 'package:kilo_iot/features/devices/presentation/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class DevicesListPage extends StatefulWidget {
  const DevicesListPage({super.key});

  @override
  State<DevicesListPage> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends State<DevicesListPage> {
  @override
  Widget build(BuildContext context) {
    final DevicesListStorage devicesListStorage =
        Provider.of<DevicesListStorage>(context, listen: true);

    final List<DeviceEntity> devicesList = devicesListStorage.devices.devices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const BrokerInfoPage(),
              //   ),
              // );
            },
            icon: const Icon(Icons.add),
          ),
        ],
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
                // ElevatedButton(
                //   onPressed: () {
                //     print('aaaaaa');
                //     devicesListStorage.addDevice(
                //       brokerId: EntityKey(key: 'id-123'),
                //       keys: ['temp', 'data'],
                //       topic: '#',
                //     );
                //   },
                //   child: Text('add random'),
                // ),

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
                              "Device ID: ${device.id.key}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Broker ID ${device.brokerId.key}",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text(
                              "Keys ${device.keys}",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text(
                              "Topic ${device.topic}",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
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
