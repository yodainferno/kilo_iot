import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kilo_iot/core/domain/usecase.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';
import 'package:kilo_iot/features/widgets/domain/repository/widget_repository.dart';

class GetWidgets implements UseCase<WidgetsListEntity, NoParams> {
  final WidgetsListRepository repository;

  GetWidgets(this.repository);
  
  // callable class
  @override
  Future<Either<Failure, WidgetsListEntity>> call(NoParams params) async {
    return await repository.getWidgets();
  }
}

class NoParams extends Equatable {
  const NoParams();
  
  @override
  List<Object?> get props => [];
}