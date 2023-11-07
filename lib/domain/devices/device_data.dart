import 'package:kilo_iot/domain/base/foreign_key.dart';

class DeviceData {
  late final ForeignKey id;
  final ForeignKey brokerId;
  final List<String> keys;

  DeviceData.withId({required this.id, required this.brokerId, required this.keys});

  DeviceData.create({required this.brokerId, required this.keys}) {
    final id = ForeignKey.generate();
    DeviceData.withId(id: id, brokerId: brokerId, keys: keys);
  }
}
