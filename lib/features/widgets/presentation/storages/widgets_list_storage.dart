import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/widgets/data/datasource/widgets_local_storage_source.dart';
import 'package:kilo_iot/features/widgets/data/repositories/widget_repository_impl.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widget_entity.dart';
import 'package:kilo_iot/features/widgets/domain/entities/widgets_list_entity.dart';
import 'package:kilo_iot/features/widgets/domain/usecases/add_widget_usecase.dart';
import 'package:kilo_iot/features/widgets/domain/usecases/delete_widget_usecase.dart';
import 'package:kilo_iot/features/widgets/domain/usecases/get_widgets_usecase.dart';
import 'package:kilo_iot/features/widgets/domain/usecases/update_widget_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetsListStorage extends ChangeNotifier {
  WidgetsListEntity widgets = const WidgetsListEntity([]);

  GetWidgets? getWidgetsUsecase;
  AddWidget? addWidgetUsecase;
  DeleteWidget? deleteWidgetUsecase;
  UpdateWidget? updateWidgetUsecase;

  WidgetsListStorage() {
    initUsecases().then((value) {
      getWidgets();
    });
  }

  Future<void> initUsecases() async {
    final sharedPreferencesInstance = await SharedPreferences.getInstance();
    final repositoryInstance = WidgetsListRepositoryImpl(
      localStorageSource: WidgetsLocalStorageSourceImpl(
        sharedPreferences: sharedPreferencesInstance,
      ),
    );

    getWidgetsUsecase = GetWidgets(repositoryInstance);
    addWidgetUsecase = AddWidget(repositoryInstance);
    deleteWidgetUsecase = DeleteWidget(repositoryInstance);
    updateWidgetUsecase = UpdateWidget(repositoryInstance);
  }

  void getWidgets() async {
    assert(getWidgetsUsecase != null);

    Either<Failure, WidgetsListEntity> data =
        await getWidgetsUsecase!(const NoParams());

    data.fold((Failure failure) {
      // erorr
      print('get');
      print(failure.name);
      print(failure.description);

    }, (WidgetsListEntity data) async {
      widgets = data;
      notifyListeners();
    });
  }

  void addWidget({
    required EntityKey deviceId,
  }) async {
    assert(addWidgetUsecase != null);

    WidgetEntity? widget;
    // try {
      widget =
          WidgetEntity.create(deviceId: deviceId);
    // } catch (_) {
    //   //
    //   return;
    // }

    Either<Failure, void> data = await addWidgetUsecase!(AddParams(
      widgetsList: widgets,
      newWidget: widget,
    ));

    data.fold((Failure failure) {
      // erorr
      print('addd');
      print(failure.name);
      print(failure.description);
    }, (_) async {
      print('hahahaha');
      getWidgets();
    });
  }

  void deleteWidget({
    required EntityKey id,
  }) async {
    assert(deleteWidgetUsecase != null);

    Either<Failure, void> data = await deleteWidgetUsecase!(DeleteParams(
      widgetsList: widgets,
      deleteId: id,
    ));

    data.fold((Failure failure) {
      // erorr
      print('delete');
      print(failure.name);
      print(failure.description);
    }, (_) async {
      getWidgets();
    });
  }

  void updateWidget({
    required EntityKey id,
    required EntityKey deviceId,
  }) async {
    assert(updateWidgetUsecase != null);

    WidgetEntity? widget;
    try {
      widget = WidgetEntity.withId(
          id: id, deviceId: deviceId);
    } catch (_) {
      //
      return;
    }

    Either<Failure, void> data = await updateWidgetUsecase!(UpdateParams(
      widgetsList: widgets,
      updatedWidget: widget,
    ));

    data.fold((Failure failure) {
      // erorr
      print('update');
      print(failure.name);
      print(failure.description);
    }, (_) async {
      getWidgets();
    });
  }
}
