import 'package:kilo_iot/domain/base/foreign_key.dart';

class WidgetData {
  late final ForeignKey id;
  final ForeignKey deviceId;

  WidgetData.withId({required this.id, required this.deviceId});

  WidgetData.create({required this.deviceId}) {
    final id = ForeignKey.generate();
    WidgetData.withId(id: id, deviceId: deviceId);
  }
}
