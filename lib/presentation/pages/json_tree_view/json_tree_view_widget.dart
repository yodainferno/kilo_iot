import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/domain/devices/device_data.dart';
import 'package:kilo_iot/domain/devices/devices_data.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';
import 'package:kilo_iot/presentation/base_components/input_widget.dart';
import 'package:kilo_iot/presentation/base_styles_configuration/material_color_generator.dart';
import 'package:kilo_iot/presentation/pages/json_tree_view/json_tree_view_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String selectedTreePathToString(List pathData) {
  return pathData.join(' -> ');
}

class JsonTreeViewWidget extends StatelessWidget {
  const JsonTreeViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JsonTreeViewStore jsonTreeViewStore =
        Provider.of<JsonTreeViewStore>(context, listen: true);

    final jsonData = jsonTreeViewStore.jsonData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Viewer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 15.0,
          ),
          child: Column(
            children: [
              Container(
                child: InformationBlock(
                  child: Column(
                    children: [
                      JsonTreeViewNode(
                        jsonData: jsonData,
                        path: const [],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Click to any value to add device keys path',
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              InformationBlock(
                child: Column(
                  children: [
                    InputWidget(
                      label: 'Ключи значения (разделение через "->")',
                      onChanged: (value) {
                        jsonTreeViewStore.inputValue = value;
                        List<String> itemsRaw = value.split('->');
                        List<String> items = List<String>.from(
                          itemsRaw.map(
                            (item) => item.trim(),
                          ),
                        );

                        if (jsonTreeViewStore.isValueExistInJsonData(items)) {
                          if (!listEquals(jsonTreeViewStore.path, items)) {
                            jsonTreeViewStore.path = items;
                          }
                        } else {
                          jsonTreeViewStore.path = [];
                        }
                      },
                      initialValue: jsonTreeViewStore.inputValue
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InputWidget(
                      label: 'Название датчика',
                      onChanged: (value) {
                        jsonTreeViewStore.nameOfDevice = value;
                      },
                      initialValue: jsonTreeViewStore.nameOfDevice
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: const Color.fromARGB(255, 12, 97, 107),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      onPressed: validate(jsonTreeViewStore) ? () async {
                        final DevicesData devicesData = Provider.of<DevicesData>(context, listen: false);
                        devicesData.add(DeviceData(

                        ));
                          String name = '';
                          List keys = [];
                          String payload = '';
                          String brokerId = '';
                          String topic = '';

                        // SharedPreferences preferences = await SharedPreferences.getInstance();

                        // final devicesString = preferences.getString('devices') ?? '[]';
                        // final devices = jsonDecode(devicesString);

                        // devices.add({
                        //   'broker_settings': {
                        //     'url': jsonTreeViewStore.broker['url'],
                        //     'port': jsonTreeViewStore.broker['port'],
                        //     'topic': jsonTreeViewStore.topic,
                        //   },
                        //   'keys': jsonTreeViewStore.path,
                        //   'name': jsonTreeViewStore.nameOfDevice,
                        // });
                        
            
                        preferences.setString('devices', jsonEncode(devices));

                        jsonTreeViewStore.nameOfDevice = '';
                        jsonTreeViewStore.path = [];
                        jsonTreeViewStore.inputValue = '';
                      } : null,
                      child: const Text("Добавить датчик"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool validate(JsonTreeViewStore jsonTreeViewStore) {
    return jsonTreeViewStore.path.isNotEmpty && jsonTreeViewStore.nameOfDevice.isNotEmpty;
  }
}

class JsonTreeViewNode extends StatelessWidget {
  final dynamic jsonData;
  final List path;

  const JsonTreeViewNode({
    Key? key,
    required this.jsonData,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JsonTreeViewStore jsonTreeViewStore =
        Provider.of<JsonTreeViewStore>(context, listen: false);
    bool isOpenedKey = listEquals(path, jsonTreeViewStore.path) == true;

    if (jsonData is Map) {
      final w = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.from(
          jsonData.entries.map((entry) {
            final currentPath = [...path, entry.key];
            final childIsNotMap = entry.value is! Map;
            final isOpened =
                childIsNotMap || jsonTreeViewStore.isOpened(currentPath);

            return IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MaterialColorGenerator.from(
                              const Color.fromARGB(255, 12, 97, 107),
                            )[700]),
                      ),
                      Expanded(
                        child: Container(
                          width: 1,
                          margin: const EdgeInsets.symmetric(
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        childIsNotMap
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  if (isOpened) {
                                    jsonTreeViewStore.close(currentPath);
                                  } else {
                                    jsonTreeViewStore.open(currentPath);
                                  }
                                },
                                child: Icon(
                                  isOpened
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  size: 16,
                                ),
                              ),
                        isOpened
                            ? JsonTreeViewNode(
                                jsonData: entry.value, path: currentPath)
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );

      return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: w,
      );
    } else {
      return GestureDetector(
        onTap: () {
          jsonTreeViewStore.path = path;
          jsonTreeViewStore.inputValue = selectedTreePathToString(path);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
          decoration: BoxDecoration(
              color: isOpenedKey
                  ? MaterialColorGenerator.from(
                      const Color.fromARGB(255, 12, 97, 107),
                    )[800]
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(3.0))),
          child: Text(
            '$jsonData',
            style: TextStyle(
              color: isOpenedKey ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }
  }
}
