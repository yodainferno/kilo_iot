import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kilo_iot/domain/devices/devices_data.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    final DevicesData devicesData =
        Provider.of<DevicesData>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Devices')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 15.0,
          ),
          child: Wrap(
            runSpacing: 20,
            children: devicesData.devices.isEmpty
                ? [
                    Container(
                      alignment: Alignment.center,
                      child: const Text('Нет данных'),
                    ),
                  ]
                : 
                List.generate(
                    devicesData.devices.length,
                    (index) {
                      final id = devicesData.devices.keys.toList()[index];
                      final deviceData = devicesData.devices[id]!;

                      return GestureDetector(
                          child: InformationBlock(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deviceData.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  "${deviceData.topic}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         // DeviceInfoPage(deviceId: id),
                            //   ),
                            // );
                          });
                    },
                  ),
          ),
        ),
      ),
    );
  }

}
