import 'dart:convert';
import 'package:kilo_iot/features/brokers/domain/entities/broker_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BrokersLocalStorageSource {
  Future<List<BrokerModel>> getBrokers();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}


const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final String? jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(triviaToCache.toJson())
    );
    return Future.value(null);
  }
}