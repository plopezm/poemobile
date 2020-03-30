import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

final mainMenuProvider = new _MainMenuProvider();

class _MainMenuProvider {
  String pageTitle;
  List<dynamic> options = [];

  Future<List<dynamic>> loadData() async {
    String jsonContent = await rootBundle.loadString("data/main_menu.json");
    Map parsedJson = json.decode(jsonContent);
    this.pageTitle = parsedJson["pageTitle"];
    this.options = parsedJson["options"];
    return this.options;
  }
}