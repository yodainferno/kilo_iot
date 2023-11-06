import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/domain/brokers/broker_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BrokersDataInt {
  String add(BrokerData newBroker);
  void update(String id, BrokerData broker);
  void delete(String id);
  void clear();

  Future syncToStore();
  Future syncFromStore();

  // void fromJson(String jsonString);
  String toJson();
}

class BrokersData extends ChangeNotifier implements BrokersDataInt {
  Map<String, BrokerData> brokers = {};
  BrokersData() {
    syncFromStore();
  }

  fromJson(String jsonString) {
    try {
      Map<String, dynamic> data = jsonDecode(jsonString);
      brokers = data.map((key, value) {
        BrokerData brokerData = BrokerData();
        brokerData.fromJson(utf8.decode(base64.decode(value)));
        return MapEntry(key, brokerData);
      });
    } catch (_) {
      brokers = {};
    }
  }

  @override
  String toJson() {
    final data = brokers.map((key, value) {
      return MapEntry(key, base64.encode(utf8.encode(value.toJson())));
    });
    return jsonEncode(data);
  }

  @override
  String add(BrokerData newBroker) {
    final String id = _generateMd5(DateTime.now().toString());
    brokers = {
      id: newBroker,
      ...brokers
    };

    notifyListeners();
    syncToStore();

    return id;
  }

  @override
  void update(String id, BrokerData broker) {
    brokers[id] = broker;
    notifyListeners();
    syncToStore();
  }

  @override
  void delete(String id) {
    brokers.remove(id);
    notifyListeners();
    syncToStore();
  }

  @override
  void clear() {
    brokers.clear();
    notifyListeners();
    syncToStore();
  }

  @override
  Future syncToStore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('brokers', toJson());
  }

  @override
  Future syncFromStore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    fromJson(preferences.getString('brokers') ?? '{}');
    notifyListeners();
  }

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
