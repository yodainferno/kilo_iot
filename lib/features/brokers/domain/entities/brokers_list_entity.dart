import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';

class BrokersListEntity {
  List<BrokerEntity> brokers = [];

  BrokersListEntity({this.brokers = const []});
}
