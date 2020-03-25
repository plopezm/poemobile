import 'package:poemobile/src/repositories/CurrencyRepository.dart';
import 'package:poemobile/src/repositories/CurrencyRepositoryImpl.dart';
import 'package:poemobile/src/repositories/MarketRepository.dart';
import 'package:poemobile/src/repositories/MarketRepositoryImpl.dart';

enum Environment {MOCK, PROD}

class Injector {

  static final Injector _singleton = new Injector._internal();
  static Environment _env;

  static void configure(Environment flavor) {
    _env = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  CurrencyRepository get currencyRepository {
    switch(_env) {
      case Environment.PROD:
        return new CurrencyRepositoryImpl();
      case Environment.MOCK:
        return null;
    }
    return null;
  }

  MarketRepository get marketRepository {
    switch(_env) {
      case Environment.PROD:
        return new MarketRepositoryImpl();
      case Environment.MOCK:
        return null;
    }
    return null;
  }

}