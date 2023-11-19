import 'package:dartz/dartz.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';

abstract class WidgetsListRepository {
  Future<Either<Failure, WidgetsListEntity>> getWidgets();
  Future<Either<Failure, void>> saveWidgets(WidgetsListEntity widgets);
}
