
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poemobile/src/pages/CurrencyPage.dart';
import 'package:poemobile/src/providers/MainMenuProvider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true
      ),
      body: _generateList(),
    );
  }

  Widget _generateList() {
    return new FutureBuilder(
      future: mainMenuProvider.loadData(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return ListView (
          children: _generateMenuItems(context),
        );
      }
    );
  }

  List<Widget> _generateMenuItems(BuildContext context) {
    final List<dynamic> options = mainMenuProvider.options;
    final List<Widget> menuItems = [SizedBox(height: 10.0)];

    options.forEach((element) {
      menuItems.add(
        ListTile(
          title: Text(element["title"]),
          leading: Image.network(element["icon"]),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.pushNamed(context, element["route"]);
          },
        ),
      );
      menuItems.add(Divider());
    });
    return menuItems;
  }
}