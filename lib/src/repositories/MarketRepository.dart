
import 'package:flutter/cupertino.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/MarketResult.dart';

abstract class MarketRepository {
  Future<List<ItemSearchResult>> fetchItem({@required PoeMarketQuery query, int offset = 0, int size = 10});
}