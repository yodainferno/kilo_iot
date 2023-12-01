import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MessagesStorage extends ChangeNotifier {
  List messagesData = [];

  void addData(MqttReceivedMessage<MqttMessage?> data) {
    messagesData.insert(0, {
      'id': EntityKey.generate(),
      'data': data,
      'created': DateTime.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
    });
    notifyListeners();
  }
}
