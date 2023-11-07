import 'dart:convert';

import 'package:kilo_iot/domain/base/foreign_key.dart';
import 'package:kilo_iot/domain/brokers/entities/broker_entity.dart';
import 'package:kilo_iot/domain/brokers/entities/brokers_entity.dart';

// это сама дата -  entity
class BrokersModel extends BrokersEntity {
  BrokersModel({required super.brokers});

  BrokersModel.fromJson(String jsonString) {
    List<BrokerEntity> brokersRaw = [];
    try {
      List<Map<String, dynamic>> jsonData =
          List<Map<String, dynamic>>.from(jsonDecode(jsonString));
      brokersRaw = List.generate(
        jsonData.length,
        (index) {
          final brokerMapData = jsonData[index];
          return BrokerEntity.withId(
            id: ForeignKey(key: brokerMapData['id']),
            url: brokerMapData['url'],
            port: brokerMapData['port'],
          );
        },
      );
    } catch (error) {
      print('BrokersFromStorage - getData: error in parsing JSON');
      print(error.toString());
    }
    
    super.brokers = brokersRaw;
  }
  // fromEntity
BrokersModel.fromEntity(BrokersEntity entity) : super(brokers: entity.brokers);

  String toJson() {
    try {
    List<Map<String, dynamic>> brokersInMapForm = List.generate(
      brokers.length,
      (index) {
        final broker = brokers[index];
        return {
          'id': broker.id.key,
          'url': broker.url,
          'port': broker.port,
        };
      },
    );
    return jsonEncode(brokersInMapForm);
    } catch(_) {
      return '[]';
    }
  }
}
