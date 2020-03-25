import 'package:flutter/material.dart';

class Currency {
  String name;
  String currencyUrl;
  ExchangeRule pay;
  ExchangeRule receive;

  Currency({@required this.name, @required this.currencyUrl});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      name: json["name"],
      currencyUrl: json["icon"]
    );
  }

  void addPay(ExchangeRule exchangeRule) {
    this.pay = exchangeRule;
  }

  void addReceive(ExchangeRule exchangeRule) {
    this.receive = exchangeRule;
  }

  @override
  String toString() {
    return "name: $name - icon: $currencyUrl";
  }
}

class ExchangeRule {
  Currency target;
  int count;
  double value;

  ExchangeRule({@required this.target, @required this.value, this.count});
}