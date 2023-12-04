import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:kilo_iot/core/domain/entity_key.dart';
import 'package:kilo_iot/core/error/failure.dart';
import 'package:kilo_iot/features/brokers/data/datasource/brokers_local_storage_source.dart';
import 'package:kilo_iot/features/brokers/data/repositories/broker_repository_impl.dart';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:kilo_iot/features/brokers/domain/entities/brokers_list_entity.dart';
import 'package:kilo_iot/features/brokers/domain/usecases/add_broker_usecase.dart';
import 'package:kilo_iot/features/brokers/domain/usecases/delete_broker_usecase.dart';
import 'package:kilo_iot/features/brokers/domain/usecases/get_brokers_usecase.dart';
import 'package:kilo_iot/features/brokers/domain/usecases/update_broker_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrokersListStorage extends ChangeNotifier {
  BrokersListEntity brokers = const BrokersListEntity([]);
  BrokerEntity? currentBroker;

  setCurrentBroker(BrokerEntity? broker) {
    currentBroker = broker;
    notifyListeners();
  }

  GetBrokers? getBrokersUsecase;
  AddBroker? addBrokerUsecase;
  DeleteBroker? deleteBrokerUsecase;
  UpdateBroker? updateBrokerUsecase;

  BrokersListStorage() {
    initUsecases().then((value) {
      getBrokers();
    });
  }

  Future<void> initUsecases() async {
    final sharedPreferencesInstance = await SharedPreferences.getInstance();
    final repositoryInstance = BrokersListRepositoryImpl(
      localStorageSource: BrokersLocalStorageSourceImpl(
        sharedPreferences: sharedPreferencesInstance,
      ),
    );

    getBrokersUsecase = GetBrokers(repositoryInstance);
    addBrokerUsecase = AddBroker(repositoryInstance);
    deleteBrokerUsecase = DeleteBroker(repositoryInstance);
    updateBrokerUsecase = UpdateBroker(repositoryInstance);
  }

  void getBrokers() async {
    assert(getBrokersUsecase != null);

    Either<Failure, BrokersListEntity> data =
        await getBrokersUsecase!(const NoParams());

    data.fold((Failure failure) {
      // erorr
    }, (BrokersListEntity data) async {
      brokers = data;
      notifyListeners();
    });
  }

  // void GetBrokerById() {
  //   GetBrokerById
  // }

  Future<Either<Failure, BrokerEntity>> addBroker({
    required String url,
    required String port,
  }) async {
    assert(addBrokerUsecase != null);

    BrokerEntity? broker;
    try {
      assert(url.isNotEmpty);

      final portInt = int.parse(port);
      broker = BrokerEntity.create(url: url, port: portInt);
    } catch (error) {
      //
      return Left(
        Failure(
          name: 'Cant add broker',
          description: error.toString(),
        ),
      );
    }

    Either<Failure, void> data = await addBrokerUsecase!(
      AddParams(
        brokersList: brokers,
        newBroker: broker,
      ),
    );
    return data.fold((Failure failure) {
      // erorr
      return Left(
        Failure(
          name: 'Cant add broker',
          description: failure.toString(),
        ),
      );
    }, (_) async {
      getBrokers();
      return Right(broker!);
    });
  }

  Future<Either<Failure, void>> deleteBroker({
    required EntityKey id,
  }) async {
    assert(deleteBrokerUsecase != null);

    Either<Failure, void> data = await deleteBrokerUsecase!(DeleteParams(
      brokersList: brokers,
      deleteId: id,
    ));

    return data.fold((Failure failure) {
      // erorr
      return Left(
        Failure(
          name: 'Cant add broker',
          description: failure.toString(),
        ),
      );
    }, (_) async {
      getBrokers();
      return const Right(null);
    });
  }

  Future<Either<Failure, BrokerEntity>> updateBroker({
    required EntityKey id,
    required String url,
    required String port,
  }) async {
    assert(updateBrokerUsecase != null);

    BrokerEntity? broker;
    try {
      assert(url.isNotEmpty);

      final portInt = int.parse(port);
      broker = BrokerEntity.withId(id: id, url: url, port: portInt);
    } catch (error) {
      //
      return Left(
          Failure(name: 'Cant update broker', description: error.toString()));
    }

    Either<Failure, void> data = await updateBrokerUsecase!(UpdateParams(
      brokersList: brokers,
      updatedBroker: broker,
    ));

    return data.fold((Failure failure) {
      // erorr
      return Left(
          Failure(name: 'Cant add broker', description: failure.toString()));
    }, (_) async {
      getBrokers();
      return Right(broker!);
    });
  }
}
