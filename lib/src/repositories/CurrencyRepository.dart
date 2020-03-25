
import 'package:poemobile/src/entities/Currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> fetchMarketCurrencyValues();
}