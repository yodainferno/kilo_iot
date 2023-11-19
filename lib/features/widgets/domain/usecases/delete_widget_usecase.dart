import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';
import 'package:kilo_iot/features/widgets/domain/repository/widget_repository.dart';

class DeleteWidget implements UseCase<void, DeleteParams> {
  final WidgetsListRepository repository;

  DeleteWidget(this.repository);

  // callable class
  @override
  Future<Either<Failure, void>> call(DeleteParams params) async {
    return await repository.saveWidgets(
      WidgetsListEntity(
        params.widgetsList.widgets
            .where((widget) => widget.id != params.deleteId)
            .toList(),
      ),
    );
  }
}

class DeleteParams extends Equatable {
  final WidgetsListEntity widgetsList;
  final EntityKey deleteId;
  const DeleteParams({required this.widgetsList, required this.deleteId});

  @override
  List<Object?> get props => [widgetsList, deleteId];
}
