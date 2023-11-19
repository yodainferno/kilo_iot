import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widget_entity.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';
import 'package:kilo_iot/features/widgets/domain/repository/widget_repository.dart';

class UpdateWidget implements UseCase<void, UpdateParams> {
  final WidgetsListRepository repository;

  UpdateWidget(this.repository);

  // callable class
  @override
  Future<Either<Failure, void>> call(UpdateParams params) async {
    List<WidgetEntity> widgets = [...params.widgetsList.widgets];
    final index =
        widgets.indexWhere((widget) => widget.id == params.updatedWidget.id);

    if (index == -1) return Left(Failure(name: 'Cant find widget to update'));

    widgets[index] = params.updatedWidget;
    return await repository.saveWidgets(WidgetsListEntity(widgets));
  }
}

class UpdateParams extends Equatable {
  final WidgetsListEntity widgetsList;
  final WidgetEntity updatedWidget;
  const UpdateParams({required this.widgetsList, required this.updatedWidget});

  @override
  List<Object?> get props => [widgetsList, updatedWidget];
}
