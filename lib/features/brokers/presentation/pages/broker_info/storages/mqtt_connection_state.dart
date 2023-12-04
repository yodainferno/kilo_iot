import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/mqtt_data_source.dart';

class MqttConnectionStorage extends ChangeNotifier {
  final defaultTTL = 300; // время жизни соединения

  MQTTConnection? mqttConnection;

  Future<bool?> connect({
    int? ttl,
  }) async {
    // todo - change provider lib
    // await Future.delayed(Duration(seconds: 1));
    final result = await mqttConnection?.connect(ttl: ttl);
    if (result == true) {
      startTimer();
      notifyListeners();
    }
    return result;
  }
  void disconect() {
    mqttConnection?.disconect();
    stopTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  Timer? _timer;
  int ttlCounter = 0;

  void startTimer() {
    ttlCounter = defaultTTL;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (ttlCounter <= 0) {
          timer.cancel();
        } else {
          ttlCounter--;
        }
        notifyListeners();
      },
    );
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
