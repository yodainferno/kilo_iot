import 'package:kilo_iot/core/domain/key.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';

class BrokerModel extends BrokerEntity {
  BrokerModel.withId(
      {required super.id, required super.url, required super.port})
      : super.withId();
  BrokerModel.create({required super.url, required super.port})
      : super.create();

  Map<String, dynamic> toJson() {
    return {
      'id': id.key,
      'url': url,
      'port': port,
    };
  }

  factory BrokerModel.fromJson(Map<String, dynamic> json) {
    return BrokerModel.withId(
      id: Key(key: json['id'] is String ? json['id'] as String : ''),
      url: json['url'] is String ? json['url'] as String : '',
      port: json['port'] is int ? json['port'] as int : 1883,
    );
  }
}
