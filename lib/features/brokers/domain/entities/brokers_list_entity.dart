import 'package:equatable/equatable.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';

class BrokersListEntity extends Equatable {
  final List<BrokerEntity> brokers;
  const BrokersListEntity(this.brokers);

  @override
  List<Object?> get props => brokers;
}
