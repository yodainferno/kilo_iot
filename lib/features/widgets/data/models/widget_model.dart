import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widget_entity.dart';

class WidgetModel extends WidgetEntity {
  WidgetModel.withId({
    required super.id,
    required super.deviceId,
  }) : super.withId();
  WidgetModel.create({
    required super.deviceId,
  }) : super.create();

  WidgetModel.fromEntity(WidgetEntity entity)
      : super.withId(
          id: entity.id,
          deviceId: entity.deviceId,
        ) {
    WidgetModel.withId(
        id: entity.id,
        deviceId: entity.deviceId);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.key,
      'device_id': deviceId.key,
    };
  }

  factory WidgetModel.fromJson(Map<String, dynamic> json) {
    return WidgetModel.withId(
      id: EntityKey(key: json['id'] is String ? json['id'] as String : ''),
      deviceId: EntityKey(key: json['device_id'] is String ? json['device_id'] as String : ''),
    );
  }
}
