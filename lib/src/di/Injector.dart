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

  CurrencyRepository _currencyRepository;
  MarketRepository _marketRepository;


  CurrencyRepository get currencyRepository {
    if (this._currencyRepository != null) {
      return this._currencyRepository;
    }
    switch(_env) {
      case Environment.PROD:
        this._currencyRepository = new CurrencyRepositoryImpl();
        return this._currencyRepository;
      case Environment.MOCK:
        return null;
    }
    return null;
  }

  MarketRepository get marketRepository {
    if (this._marketRepository != null) {
      return this._marketRepository;
    }
    switch(_env) {
      case Environment.PROD:
        this._marketRepository =  new MarketRepositoryImpl();
        return this._marketRepository;
      case Environment.MOCK:
        return null;
    }
    return null;
  }

}