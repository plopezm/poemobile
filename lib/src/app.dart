import 'package:flutter/material.dart';
import 'package:poemobile/src/pages/CurrencyPage.dart';
import 'package:poemobile/src/pages/HomePage.dart';
import 'package:poemobile/src/pages/MarketPage.dart';

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