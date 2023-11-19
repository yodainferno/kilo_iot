import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widget_entity.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';
import 'package:kilo_iot/features/widgets/domain/repository/widget_repository.dart';

class AddWidget implements UseCase<void, AddParams> {
  final WidgetsListRepository repository;

  AddWidget(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, void>> call(AddParams params) async {
    return await repository.saveWidgets(
      WidgetsListEntity([ // добавляем в начало
        params.newWidget,
        ...params.widgetsList.widgets,
      ])
    );
  }
}

class AddParams extends Equatable {
  final WidgetsListEntity widgetsList;
  final WidgetEntity newWidget;
  const AddParams({required this.widgetsList, required this.newWidget});
  
  @override
  List<Object?> get props => [widgetsList, newWidget];
}
