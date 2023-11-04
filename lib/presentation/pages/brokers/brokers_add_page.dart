import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kilo_iot/data/data_sources/mqtt_connection.dart';
import 'package:kilo_iot/presentation/base_components/information_block.dart';
import 'package:kilo_iot/presentation/base_components/input_widget.dart';
import 'package:kilo_iot/presentation/base_styles_configuration/material_color_generator.dart';
import 'package:kilo_iot/presentation/pages/json_tree_view/json_tree_view_store.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BrokersAddPage extends StatefulWidget {
  final TTL = 300;

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

  Timer? _timer;
  int _ttlCounter = 0;

  Map<int, bool> marks = {};
  int currentId = 1;

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

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
            InformationBlock(
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
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            backgroundColor: mqttConnection?.isConnected == true
                                ? Colors.red[900]
                                : MaterialColorGenerator.from(
                                    const Color.fromARGB(255, 12, 97, 107),
                                  ),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            )),
                        onPressed: mqttConnection?.isStatusChanging == true
                            ? null
                            : () async {
                                if (mqttConnection?.isConnected == true) {
                                  mqttConnection?.disconect();
                                  stopTimer();
                                  setState(() {});
                                } else {
                                  mqttConnection = MQTTConnection(
                                    address: formState['address'],
                                    port: int.parse(formState['port']),
                                  );
                                  await mqttConnection?.connect(
                                      ttl: widget.TTL);
                                  mqttConnection?.listenTopics(
                                    callBack: (MqttReceivedMessage<MqttMessage?>
                                        data) {
                                      setState(
                                        () {
                                          messagesData.insert(0, {
                                            'id': currentId,
                                            'data': data,
                                            'created': DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch),
                                          });
                                          marks[currentId] = false;
                                          currentId++;
                                        },
                                      );
                                    },
                                  );
                                  startTimer();
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
                                    ? 'Отключиться сейчас'
                                    : 'Подключиться',
                              ),
                      ),
                      mqttConnection?.isConnected == true
                          ? Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "До автоматического отключения: $_ttlCounter сек.",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14.0,
                                ),
                              ),
                            )
                          : messagesData.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(40),
                                      backgroundColor: Colors.red[900],
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                    ),
                                    child: Text(
                                        "Очистить (${messagesData.length})"),
                                    onPressed: () {
                                      setState(() {
                                        messagesData = [];
                                        marks = {};
                                      });
                                    },
                                  ),
                                )
                              : Container(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: messagesData.isNotEmpty ? 30.0 : 0.0),
            ...List<Widget>.generate(
              messagesData.length,
              (index) {
                final MqttReceivedMessage<MqttMessage?> messageData =
                    messagesData[index]['data'];
                final DateTime created = messagesData[index]['created'];
                final int id = messagesData[index]['id'];
                final bool isMarked = marks[id] == true;

                String formattedMilliseconds =
                    created.millisecond.toString().padLeft(3, '0');

                return GestureDetector(
                  child: InformationBlock(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DateFormat('HH:mm:ss').format(created)}.$formattedMilliseconds',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 16),
                              ),
                              Text(
                                "Topic: ${messageData.topic}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            isMarked ? Icons.bookmark :  Icons.bookmark_outline,
                            color: const Color.fromARGB(255, 12, 97, 107),
                          ),
                          onTap: () {
                            setState(() {
                              marks[id] = !isMarked;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    final recMess = messageData.payload as MqttPublishMessage;
                    final jsonDataString =
                        MqttPublishPayload.bytesToStringAsString(
                            recMess.payload.message);

                    JsonTreeViewStore jsonTreeViewStore =
                        Provider.of<JsonTreeViewStore>(context, listen: false);

                    Map jsonData = {};
                    try {
                      jsonData = json.decode(jsonDataString);
                    } catch (_) {}
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

  void startTimer() {
    _ttlCounter = widget.TTL;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_ttlCounter <= 0) {
            timer.cancel();
          } else {
            _ttlCounter--;
          }
        });
      },
    );
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
