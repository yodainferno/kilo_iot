import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kilo_iot/data/data_sources/mqtt_connection.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';
import 'package:kilo_iot/presentation/base_components/input_widget.dart';
import 'package:kilo_iot/presentation/pages/json_tree_view/json_tree_view_store.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BrokersAddPage extends StatefulWidget {
  const BrokersAddPage({super.key});

  @override
  BrokersAddPageState createState() => BrokersAddPageState();
}

class BrokersAddPageState extends State<BrokersAddPage> {
  final Map<String, dynamic> formState = {
    'address': 'mqtt.34devs.ru',
    'port': '1883',
  };

  final Map<String, Map<String, String?>> formFields = {
    'address': {'label': 'Адрес сервера-брокера'},
    'port': {'label': 'Порт сервера-брокера'},
  };

  MQTTConnection? mqttConnection;
  List messagesData = []; // MqttReceivedMessage<MqttMessage?>

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Broker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 15.0,
        ),
        child: Wrap(
          runSpacing: 20,
          children: [
            ...formFields.keys.map(
              (fieldKey) {
                return InputWidget(
                  initialValue: formState[fieldKey],
                  onChanged: (String newValue) {
                    setState(() {
                      formState[fieldKey] = newValue;
                    });
                  },
                  //
                  label: formFields[fieldKey]?['label'],
                );
              },
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: mqttConnection?.isStatusChanging == true
                  ? null
                  : () async {
                      if (mqttConnection?.isConnected == true) {
                        mqttConnection?.disconect();
                        setState(() {});
                      } else {
                        mqttConnection = MQTTConnection(
                          address: formState['address'],
                          port: int.parse(formState['port']),
                        );
                        await mqttConnection?.connect(ttl: 300);
                        mqttConnection?.listenTopics(
                          callBack: (MqttReceivedMessage<MqttMessage?> data) {
                            setState(
                              () {
                                messagesData.insert(0, {
                                  'data': data,
                                  'created': DateTime.now(),
                                });
                              },
                            );
                          },
                        );
                        messagesData = [];
                        setState(() {});
                        // mqtt.disconect();
                      }
                    },
              child: mqttConnection?.isStatusChanging == true
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      mqttConnection?.isConnected == true
                          ? 'Отключиться'
                          : 'Подключиться',
                    ),
            ),
            SizedBox(height: messagesData.isNotEmpty ? 30.0 : 0.0),
            ...List<Widget>.generate(
              messagesData.length,
              (index) {
                final MqttReceivedMessage<MqttMessage?> messageData =
                    messagesData[index]['data'];
                final DateTime created = messagesData[index]['created'];

                return GestureDetector(
                  child: InformationBlock(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('HH:mm:ss').format(created),
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                        Text(
                          "Topic: ${messageData.topic}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    final recMess = messageData.payload as MqttPublishMessage;
                    final jsonDataString = MqttPublishPayload.bytesToStringAsString(
                        recMess.payload.message);

                    JsonTreeViewStore jsonTreeViewStore =
                        Provider.of<JsonTreeViewStore>(context, listen: false);
                    
                    Map jsonData = {};
                    try {
                      jsonData = json.decode(jsonDataString);
                    } catch(_) {}
                    jsonTreeViewStore.jsonData = jsonData; 

                    Navigator.pushNamed(context, '/base/json_viewer');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
