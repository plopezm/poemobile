import 'package:flutter/material.dart';
import 'package:poemobile/src/components/DataTable.dart';
import 'package:poemobile/src/di/Injector.dart';
import 'package:poemobile/src/entities/Currency.dart';
import 'package:poemobile/src/repositories/CurrencyRepository.dart';

class CurrencyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurrencyPageState();
  }
}

class _CurrencyPageState extends State<CurrencyPage> {
  final CurrencyRepository currencyRepository = Injector().currencyRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Currency Status"), centerTitle: true),
      body: new Container(
        child: Center(
          child: RefreshIndicator(
            child: _getFutureBuilder(),
            onRefresh: () async {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  FutureBuilder _getFutureBuilder() {
    return FutureBuilder(
      future: currencyRepository.fetchMarketCurrencyValues(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Container(
                child: Center(child: CircularProgressIndicator())
            );
          default:
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else {
              //return _createListView(context, snapshot);
              return DynamicDataTableComponent(
                tableHeaders: <String>["Currency", "1x Currency", "1x Chaos"],
                rows: snapshot.data,
                onRowFormat: (element) {
                  if (element.pay == null && element.receive == null) {
                    return <DataCell>[];
                  }
                  return <DataCell>[
                    DataCell(_getCurrencyColumn(element)),
                    DataCell(_getPayInfo(element.receive)),
                    DataCell(_getPayInfo(element.pay))
                  ];
                },
              );
            }
        }
      },
    );
  }

  Widget _getCurrencyColumn(Currency currency) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.network(currency.currencyUrl),
        Text(currency.name),
      ],
    );
  }

  Widget _getPayInfo(ExchangeRule exchangeRule) {
    if (exchangeRule == null) {
      return Column();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network(exchangeRule.target.currencyUrl),
        SizedBox(width: 10.0),
        Text("${exchangeRule.value.toStringAsFixed(2)}")
      ],
    );
  }
}
