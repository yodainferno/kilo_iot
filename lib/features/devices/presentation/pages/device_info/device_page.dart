import 'package:flutter/material.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/devices/presentation/pages/device_info/storages/device_info_form_state.dart';
import 'package:kilo_iot/features/devices/presentation/pages/device_info/widgets/broker_info_widget.dart';
import 'package:kilo_iot/features/devices/presentation/pages/device_info/widgets/crud_device_widget.dart';
import 'package:kilo_iot/features/devices/presentation/pages/device_info/widgets/device_form_widget.dart';
import 'package:kilo_iot/features/devices/presentation/pages/devices_list/storages/brokers_list_storage.dart';
import 'package:provider/provider.dart';

class DeviceInfoPage extends StatelessWidget {
  const DeviceInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    DevicesListStorage devicesListStorage =
        Provider.of<DevicesListStorage>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              DeviceInfoFormStorage(devicesListStorage.currentDevice),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(devicesListStorage.currentDevice != null ? 'Датчик' : 'Новый датчик'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 15.0,
            ),
            child: Column(
              children: [
                InformationBlock(
                  child: const BrokerInfoWidget(),
                ),
                const SizedBox(height: 15.0),
                InformationBlock(
                  child: DeviceFormWidget(),
                ),
                const SizedBox(height: 15.0),
                CrudDeviceWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
