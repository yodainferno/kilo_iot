import 'package:kilo_iot/features/brokers/data/models/broker_model.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';

class BrokersListModel extends BrokersListEntity {
  late final List<BrokerEntity> brokers;

  BrokersListModel(this.brokers) : super(brokers);

  BrokersListModel.fromEntity(BrokersListEntity entity) : super(entity.brokers) {
    brokers = entity.brokers;
  }

  List<Map<String, dynamic>> toJson() {
    return brokers.map((broker) => BrokerModel.fromEntity(broker).toJson()).toList();
  }

  factory BrokersListModel.fromJson(List<dynamic> json) {
    List<Map<String, dynamic>> jsonTyped = json.map((element) => element as Map<String, dynamic>).toList();
    final List<BrokerModel> brokersList =
        jsonTyped.map((Map<String, dynamic> brokerJson) => BrokerModel.fromJson(brokerJson)).toList();

    return BrokersListModel(brokersList);
  }
}
