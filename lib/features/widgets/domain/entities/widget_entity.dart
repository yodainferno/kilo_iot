
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';

class WidgetEntity extends Equatable {
  late final EntityKey id;
  late final EntityKey deviceId;

  WidgetEntity.withId({required this.id, required this.deviceId});

  WidgetEntity.create({required this.deviceId}) {
    id = EntityKey.generate();
    WidgetEntity.withId(id: id, deviceId: deviceId);
  }
  
  @override
  List<Object?> get props => [id, deviceId];
}
