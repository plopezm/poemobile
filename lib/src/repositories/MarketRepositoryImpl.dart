import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/MarketResult.dart';
import 'package:poemobile/src/entities/Pagination.dart';
import 'package:poemobile/src/entities/Stats.dart';
import 'package:poemobile/src/repositories/MarketRepository.dart';

class MarketRepositoryImpl extends MarketRepository {
  List<Stats> cachedStats;
  Map<String, _IndexResult> _cachedQueries = {};

  @override
  Future<Page<ItemSearchResult>> fetchItem(String term,
      {@required PoeMarketQuery query, int offset = 0, int size = 10}) async {
    query.query.term = term;
    // Getting indexes
    String queryJson = json.encode(query.toJson());
    print("Sending queryJson: $queryJson");
    http.Response response = await http.post(
        'https://www.pathofexile.com/api/trade/search/Delirium',
        body: queryJson,
        headers: <String, String>{"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed reading market indexes: ${response.body}');
    }
    this._cachedQueries.clear();
    final parsedIndexResult = json.decode(response.body);
    _IndexResult indexResult = _IndexResult.fromJson(parsedIndexResult);

    if (indexResult.total == 0) {
      return Page(total: 0, offset: offset, pageSize: size, content: ItemSearchResult.listFromJson([]));
    }

    // Getting real info
    int end = offset + size;
    String idsToFetch = indexResult.result
        .sublist(offset, end >= indexResult.total ? indexResult.total : end)
        .join(",");

    if (end < indexResult.total) {
      this._cachedQueries[indexResult.id] = indexResult;
    }

    final String fetchUrl = 'https://www.pathofexile.com/api/trade/fetch/$idsToFetch?query=${indexResult.id}';
    response = await http.get(
        fetchUrl,
        headers: <String, String>{"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed getting results: ${response.body}');
    }
    final parsedResult = json.decode(response.body);
    return Page(
        total: indexResult.total,
        offset: offset,
        pageSize: size,
        queryId: indexResult.id,
        content: ItemSearchResult.listFromJson(parsedResult["result"])
    );
  }

  @override
  Future<Page<ItemSearchResult>> fetchItemByQueryId({@required String queryId, int offset = 0, int size = 10}) async {
    final _IndexResult nextIds = this._cachedQueries[queryId];
    if (nextIds == null) {
      throw Exception('Query does not exist');
    }

    // Getting real info
    int end = offset + size;
    String idsToFetch = nextIds.result
        .sublist(offset, end >= nextIds.result.length ? nextIds.result.length : end)
        .join(",");

    final String fetchUrl = 'https://www.pathofexile.com/api/trade/fetch/$idsToFetch?query=$queryId';
    final http.Response response = await http.get(
        fetchUrl,
        headers: <String, String>{"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed getting results: ${response.body}');
    }
    final parsedResult = json.decode(response.body);
    return Page(
        total: nextIds.total,
        offset: offset,
        pageSize: size,
        content: ItemSearchResult.listFromJson(parsedResult["result"])
    );
  }

  @override
  Future<List<Stats>> fetchStats() async {
    if (cachedStats != null) {
      return cachedStats;
    }

    http.Response response = await http.get(
        'https://www.pathofexile.com/api/trade/data/stats',
        headers: <String, String>{"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed getting results: ${response.body}');
    }
    final parsedResult = json.decode(response.body);
    cachedStats = Stats.listFromJson(parsedResult["result"]);
    return Future.value(cachedStats);
  }
}

class _IndexResult {
  String id;
  List result;
  int total;

  _IndexResult({this.id, this.total, this.result});

  factory _IndexResult.fromJson(Map<String, dynamic> parsedJson) {
    return _IndexResult(
        id: parsedJson["id"],
        total: parsedJson["total"],
        result: parsedJson["result"]);
  }
}
