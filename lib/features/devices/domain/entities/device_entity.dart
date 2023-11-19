
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';

class DeviceEntity extends Equatable {
  late final EntityKey id;
  late final EntityKey brokerId;
  final List<String> keys;
  final String topic;

  DeviceEntity.withId({required this.id, required this.brokerId, required this.keys, required this.topic});

  DeviceEntity.create({required this.brokerId, required this.keys, required this.topic}) {
    id = EntityKey.generate();
    DeviceEntity.withId(id: id, brokerId: brokerId, keys: keys, topic: topic);
  }
  
  @override
  List<Object?> get props => [id, brokerId, keys, topic];
}
