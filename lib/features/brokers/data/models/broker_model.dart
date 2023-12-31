import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';

class BrokerModel extends BrokerEntity {
  BrokerModel.withId(
      {required super.id, required super.name, required super.url, required super.port})
      : super.withId();
  BrokerModel.create({required super.name, required super.url, required super.port})
      : super.create();

  BrokerModel.fromEntity(BrokerEntity entity) : super.withId(id: entity.id, name: entity.name, url: entity.url, port: entity.port) {
    BrokerModel.withId(id: entity.id, name: entity.name, url: entity.url, port: entity.port);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.key,
      'name': name,
      'url': url,
      'port': port,
    };
  }

  factory BrokerModel.fromJson(Map<String, dynamic> json) {
    return BrokerModel.withId(
      id: EntityKey(key: json['id'] is String ? json['id'] as String : ''),
      name: json['name'] is String ? json['name'] as String : '',
      url: json['url'] is String ? json['url'] as String : '',
      port: json['port'] is int ? json['port'] as int : 1883,
    );
  }
}
