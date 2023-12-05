import 'package:flutter/material.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';

class BrokerFormStorage extends ChangeNotifier {
  setStateFromBroker(BrokerEntity? broker) {
    if (broker != null) {
      state['name'] = broker.name;
      state['address'] = broker.url;
      state['port'] = broker.port.toString();
    } else {
      state['name'] = '';
      state['address'] = '';
      state['port'] = '';
    }
  }
  String getFieldState(String key) {
    return state[key] ?? '';
  }

  void setFieldState(String key, String newValue) {
    if (state.containsKey(key)) {
      state[key] = newValue;
      notifyListeners();
    }
  }

  final Map<String, dynamic> state = {
    'name': '',
    'address': '',
    'port': '',
  };
}
