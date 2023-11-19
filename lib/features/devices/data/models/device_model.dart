import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/devices/domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  DeviceModel.withId({
    required super.id,
    required super.brokerId,
    required super.keys,
    required super.topic,
  }) : super.withId();
  DeviceModel.create({
    required super.brokerId,
    required super.keys,
    required super.topic,
  }) : super.create();

  DeviceModel.fromEntity(DeviceEntity entity)
      : super.withId(
          id: entity.id,
          brokerId: entity.brokerId,
          keys: entity.keys,
          topic: entity.topic,
        ) {
    DeviceModel.withId(
        id: entity.id,
        brokerId: entity.brokerId,
        keys: entity.keys,
        topic: entity.topic);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.key,
      'broker_id': brokerId.key,
      'keys': keys,
      'topic': topic,
    };
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {

    List<String> keys = [...(json['keys'] is List ? json['keys'].map((key) => key.toString()).toList() : [])];

    return DeviceModel.withId(
      id: EntityKey(key: json['id'] is String ? json['id'] as String : ''),
      brokerId: EntityKey(key: json['broker_id'] is String ? json['broker_id'] as String : ''),
      keys: keys,
      topic: json['topic'] is String ? json['topic'] as String : '',
    );
  }
}
