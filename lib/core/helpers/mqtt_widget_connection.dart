import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/mqtt_data_source.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/presentation/pages/brokers_list/storages/brokers_list_storage.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';

class MqttWidgetConnection extends ChangeNotifier {
  Map<String, MQTTConnection> mqttConnections = {};
  Map<String, Map<String, dynamic>> storeData = {};

  void connect(context) async {
    final BrokersListStorage brokersListStorage =
        Provider.of<BrokersListStorage>(
      context,
      listen: false,
    );
    await Future.delayed(const Duration(milliseconds: 0));
    brokersListStorage.getBrokers();

    for (BrokerEntity broker in brokersListStorage.brokers.brokers) {
      String key = "${broker.url}:${broker.port}";
      if (mqttConnections.containsKey(key)) continue;

      mqttConnections[key] = MQTTConnection(
        address: broker.url,
        port: broker.port,
      );
      await mqttConnections[key]!.connect();
      mqttConnections[key]?.listenTopics(
        callBack: (MqttReceivedMessage<MqttMessage?> data) {
          final recMess = data.payload as MqttPublishMessage;
          final jsonDataString =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          Map jsonData = {};
          try {
            jsonData = json.decode(jsonDataString);
            writeMessageToStore(key, data.topic, jsonData);

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
  }

  void reconnect(BuildContext context) async {
    disconect();
    connect(context);
  }

  void disconect() {
    // mqttConnection?.disconect();
  }

  void writeMessageToStore(String key, String topic, dynamic data) {
    if (!storeData.containsKey(key)) {
      storeData[key] = {};
    }
    storeData[key]![topic] = data;
    notifyListeners();
  }

  String getDataByTopicKeys(String key, String topic, List<String> keys) {
    if (storeData[key] == null || storeData[key]?[topic] == null) return '';
    return _getDataByKeys(storeData[key]?[topic], keys).toString();
  }

  dynamic _getDataByKeys(dynamic object, List<String> keys) {
    if (keys.isEmpty || object.isEmpty) return null;

    dynamic currentKey = keys[0];
    if (object is List) {
      currentKey = int.parse(currentKey);
    }
    final data = object[currentKey];
    if (data is Map || data is List) {
      return _getDataByKeys(data, keys.sublist(1));
    } else {
      return data;
    }
  }
}
