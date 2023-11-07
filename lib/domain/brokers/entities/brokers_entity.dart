
import 'package:kilo_iot/domain/brokers/entities/broker_entity.dart';

// это сама дата -  entity
class BrokersEntity {
  List<BrokerEntity> brokers = [];

  BrokersEntity({this.brokers = const []});
}
