import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/mqtt_data_source.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttWidgetConnection extends ChangeNotifier {
  MQTTConnection? mqttConnection;
  Map<String, dynamic> storeData = {};


  void connect() async {
    mqttConnection = MQTTConnection(
      address: 'mqtt.34devs.ru',
      port: 1883,
    );
    await mqttConnection!.connect();
    mqttConnection?.listenTopics(
      callBack: (MqttReceivedMessage<MqttMessage?> data) {
        final recMess = data.payload as MqttPublishMessage;
        final jsonDataString =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        Map jsonData = {};
        try {
          jsonData = json.decode(jsonDataString);
          writeMessageToStore(data.topic, jsonData);

          // final keys = ['sn', 'Time'];
          // final wD = getDataByKeys(jsonData, keys);

          // if (wD != null) {
          //   setState(() {
          //     widgetData = wD.toString();
          //   });
          // }
        } catch (_) {}
      },
    );
  }

  void reconnect() async{
    disconect();
    connect();
  }
  void disconect() {
    mqttConnection?.disconect();
  }

  void writeMessageToStore(String topic, dynamic data) {
    storeData[topic] = data;
    notifyListeners();
  }

  String getDataByTopicKeys(String topic, List<String> keys) {
    if (storeData[topic] == null) return '';
    return _getDataByKeys(storeData[topic], keys).toString();
  }

  dynamic _getDataByKeys(Map object, List<String> keys) {
    if (keys.isEmpty || object.isEmpty) return null;

    final data = object[keys[0]];
    if (data is Map) {
      return _getDataByKeys(data, keys.sublist(1));
    } else {
      return data;
    }
  }
}
