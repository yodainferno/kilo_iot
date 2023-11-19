import 'package:equatable/equatable.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widget_entity.dart';

class WidgetsListEntity extends Equatable {
  final List<WidgetEntity> widgets;
  const WidgetsListEntity(this.widgets);

  @override
  List<Object?> get props => widgets;
}
