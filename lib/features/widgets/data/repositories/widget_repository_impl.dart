import 'package:dartz/dartz.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/widgets/data/datasource/widgets_local_storage_source.dart';
import 'package:kilo_iot/features/widgets/data/models/widgets_list_model.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';
import 'package:kilo_iot/features/widgets/domain/repository/widget_repository.dart';

class WidgetsListRepositoryImpl implements WidgetsListRepository {
  final WidgetsLocalStorageSource localStorageSource;

  WidgetsListRepositoryImpl({
    required this.localStorageSource
  });

  @override
  Future<Either<Failure, WidgetsListEntity>> getWidgets() async{
    try {
      return Right(await localStorageSource.getWidgets());
    } catch(error) {
      return Left(Failure(name: 'Error in getting widgets', description: error.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> saveWidgets(WidgetsListEntity widgets) async {
    WidgetsListModel widgetsModel = WidgetsListModel.fromEntity(widgets);
    try {
      return Right(await localStorageSource.saveWidgets(widgetsModel));
    } catch(error) {
      return Left(Failure(name: 'Error in getting widgets', description: error.toString()));
    }
  }
}
