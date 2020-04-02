
import 'package:flutter/cupertino.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/MarketResult.dart';
import 'package:poemobile/src/entities/Pagination.dart';
import 'package:poemobile/src/entities/Stats.dart';

abstract class MarketRepository {
  Future<List<Stats>> fetchStats();
  Future<Page<ItemSearchResult>> fetchItem(String term, {@required PoeMarketQuery query, int offset = 0, int size = 10});
  Future<Page<ItemSearchResult>> fetchItemByQueryId({@required String queryId, int offset = 0, int size = 10});
}