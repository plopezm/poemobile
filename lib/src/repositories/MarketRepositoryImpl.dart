import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/MarketResult.dart';
import 'package:poemobile/src/repositories/MarketRepository.dart';

class MarketRepositoryImpl extends MarketRepository {
  @override
  Future<List<ItemSearchResult>> fetchItem(String term,
      {@required PoeMarketQuery query, int offset = 0, int size = 10}) async {
    query.query.term = term;
    // Getting indexes
    String queryJson = json.encode(query.toJson());
    http.Response response = await http.post(
        'https://www.pathofexile.com/api/trade/search/Delirium',
        body: queryJson,
        headers: <String, String>{"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed reading market indexes: ${response.body}');
    }
    final parsedIndexResult = json.decode(response.body);
    _IndexResult indexResult = _IndexResult.fromJson(parsedIndexResult);

    // Getting real info
    int end = offset + size;
    String idsToFetch = indexResult.result
        .sublist(offset, end >= indexResult.total ? indexResult.total - 1 : end)
        .join(",");
    response = await http.get(
        'https://www.pathofexile.com/api/trade/fetch/$idsToFetch?query=${indexResult.id}',
        headers: <String, String>{"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed getting results: ${response.body}');
    }
    final parsedResult = json.decode(response.body);
    return ItemSearchResult.listFromJson(parsedResult["result"]);
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
