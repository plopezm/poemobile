import 'package:flutter/material.dart';
import 'package:poemobile/src/pages/currency_page.dart';
import 'package:poemobile/src/pages/home_page.dart';
import 'package:poemobile/src/pages/market_page.dart';

class PoeMobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: <String, WidgetBuilder> {
        "/": (BuildContext context) => HomePage(),
        "/currency": (BuildContext context) => CurrencyPage(),
        "/market": (BuildContext context) => MarketPage(),
      },
    );
  }
}