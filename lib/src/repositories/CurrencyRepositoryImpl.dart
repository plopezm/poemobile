import 'dart:convert';

import 'package:poemobile/src/entities/Currency.dart';
import 'package:poemobile/src/repositories/CurrencyRepository.dart';

import 'package:http/http.dart' as http;

class CurrencyRepositoryImpl extends CurrencyRepository {
  @override
  Future<List<Currency>> fetchMarketCurrencyValues() async {
    final http.Response response = await http.get('https://poe.ninja/api/data/currencyoverview?league=Delirium&type=Currency&language=en');
    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
    final parsedJson = json.decode(response.body);
    final currencyDetails = parsedJson["currencyDetails"] as List<dynamic>;
    final lines = parsedJson["lines"] as List<dynamic>;

    List<Currency> fetchedCurrencyList = [];
    for (int i = 0;i<currencyDetails.length;i++) {
      fetchedCurrencyList.add(Currency.fromJson(currencyDetails[i]));
    }

    for (int i = 0;i<lines.length;i++) {
      if (lines[i]["pay"] == null) {
        continue;
      }
      final currentPayLine = lines[i]["pay"] as Map<String, dynamic>;
      final sourcePayCurrencyId = currentPayLine["pay_currency_id"]-1;
      final destinationPayCurrencyId = currentPayLine["get_currency_id"]-1;
      final payExchange = ExchangeRule(target: fetchedCurrencyList[sourcePayCurrencyId], value: currentPayLine["value"]);

      fetchedCurrencyList[sourcePayCurrencyId].addPay(payExchange);

      final currentReceiveLine = lines[i]["receive"] as Map<String, dynamic>;
      final sourceReceiveCurrencyId = currentReceiveLine["pay_currency_id"]-1;
      final destinationReceiveCurrencyId = currentReceiveLine["get_currency_id"]-1;
      final receiveExchange = ExchangeRule(target: fetchedCurrencyList[sourceReceiveCurrencyId], value: currentReceiveLine["value"]);

      fetchedCurrencyList[destinationReceiveCurrencyId].addReceive(receiveExchange);
    }

    return fetchedCurrencyList;
  }
}