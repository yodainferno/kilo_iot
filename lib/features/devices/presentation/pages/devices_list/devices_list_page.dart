import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/core/helpers/mqtt_widget_connection.dart';
import 'package:kilo_iot/core/presentation/base_components/information_block.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
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
  // dynamic getDataByKeys(Map object, List<String> keys) {
  //   if (keys.isEmpty || object.isEmpty) return null;

  //   final data = object[keys[0]];
  //   if (data is Map) {
  //     return getDataByKeys(data, keys.sublist(1));
  //   } else {
  //     return data;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final DevicesListStorage devicesListStorage =
        Provider.of<DevicesListStorage>(context, listen: true);

    final List<DeviceEntity> devicesList = devicesListStorage.devices.devices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список датчиков'),
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

    final BrokersListStorage brokersListStorage =
        Provider.of<BrokersListStorage>(context, listen: false);

    return List.generate(
      devicesList.length,
      (index) {
        DeviceEntity device = devicesList[index];
        final brokerData = brokersListStorage.getBrokerById(device.brokerId);
        final brokerKey =
            brokerData != null ? "${brokerData.url}:${brokerData.port}" : "";

        final deviceData = mqttWidgetConnection.getDataByTopicKeys(
          brokerKey,
          device.topic,
          device.keys,
        );

        final deviceDataLast =
            deviceData.isEmpty ? '' : deviceData[deviceData.length - 1];

        return GestureDetector(
          child: InformationBlock(
            child: Stack(
              children: [
                Column(
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
                    deviceData is List<num>
                        ? Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: chart(deviceData),
                          )
                        : Text(
                            deviceDataLast.toString(),
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ],
                ),
                brokerData == null
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red[900],
                        ),
                      )
                    : Container()
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

  Widget chart(List<num> dataRaw) {
    dataRaw = [10, 10.2, 10.9, 13.0, 13.1, 11.0, 8.3];
    if (dataRaw.length == 1) {
      dataRaw.add(dataRaw[0]);
    }
    final List<FlSpot> data = List.generate(dataRaw.length,
        (index) => FlSpot(index.toDouble(), dataRaw[index].toDouble()));

    return Container(
      height: 100,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white.withOpacity(0.8),
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(),
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
