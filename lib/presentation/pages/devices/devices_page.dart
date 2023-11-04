import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceData {
  final String brokerUrl;
  final String brokerPort;
  final String brokerTopic;

  final List keys;
  final String name;

  DeviceData(
      {required this.brokerUrl,
      required this.brokerPort,
      required this.brokerTopic,
      required this.keys,
      required this.name});
}

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final List<DeviceData> devices = [];

  _DevicesPageState();

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devices')),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  void getDevices() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // preferences.setString('devices', '[{"name": "Device 1"}, {"name": "Device 2"}]');

    final devicesLocalString = preferences.getString('devices') ?? '[]';
    final devicesLocal = jsonDecode(devicesLocalString);
    for (var device in devicesLocal) {
      devices.add(
        DeviceData(
          brokerUrl: device['broker_settings']['url'],
          brokerPort: device['broker_settings']['port'],
          brokerTopic: device['broker_settings']['topic'],
          keys: device['keys'],
          name: device['name'],
        ),
      );
    }
    setState(() {});
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
        child: Wrap(
          runSpacing: 20,
          children: List<Widget>.generate(
            devices.length,
            (index) {
              return InformationBlock(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${devices[index].brokerUrl}:${devices[index].brokerPort}"),
                    Text(devices[index].brokerTopic),
                    Text(devices[index].name),
                    Text(devices[index].keys.join(' -> ')),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
