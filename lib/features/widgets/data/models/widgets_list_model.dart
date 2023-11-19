import 'package:kilo_iot/features/widgets/data/models/widget_model.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widget_entity.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';

class WidgetsListModel extends WidgetsListEntity {
  late final List<WidgetEntity> widgets;

  WidgetsListModel(this.widgets) : super(widgets);

  WidgetsListModel.fromEntity(WidgetsListEntity entity) : super(entity.widgets) {
    widgets = entity.widgets;
  }

  List<Map<String, dynamic>> toJson() {
    return widgets.map((widget) => WidgetModel.fromEntity(widget).toJson()).toList();
  }

  factory WidgetsListModel.fromJson(List<dynamic> json) {
    List<Map<String, dynamic>> jsonTyped = json.map((element) => element as Map<String, dynamic>).toList();
    final List<WidgetModel> widgetsList =
        jsonTyped.map((Map<String, dynamic> widgetJson) => WidgetModel.fromJson(widgetJson)).toList();

    return WidgetsListModel(widgetsList);
  }
}
