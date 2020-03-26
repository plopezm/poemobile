import 'package:flutter/material.dart';
import 'package:poemobile/src/components/data_table.dart';
import 'package:poemobile/src/components/item_list.dart';
import 'package:poemobile/src/di/Injector.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/MarketResult.dart';
import 'package:poemobile/src/repositories/MarketRepository.dart';

class MarketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MarketPageState();
  }
}

class _MarketPageState extends State<MarketPage> {
  MarketRepository marketRepository = Injector().marketRepository;

  String itemName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Market"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              this.setState(() { });
            },
          )
        ],
      ),
      body: new Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Center(
            child: RefreshIndicator(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: "Item name"),
                        onChanged: (value) {
                          this.itemName = value;
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: _getFutureBuilder(),
                  ),
                ],
              ),
              onRefresh: () async {
                this.setState(() {});
              },
            ),
          )),
    );
  }

  FutureBuilder _getFutureBuilder() {
    return FutureBuilder(
        future: this.marketRepository.fetchItem(
            query: PoeMarketQuery(
                query: PoeMarketQuerySpec(
                  term: this.itemName,
                  status: PoeMarketQueryStatus(option: "online"),
                  stats: <PoeMarketFilter>[
                    PoeMarketFilter(
                        type: "and", filters: <PoeMarketFilterSpec>[])
                  ],
                ),
                sort: PoeMarketQuerySort(price: "asc"))),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Container(child: Text('Loading...'), padding: EdgeInsets.all(12.0));
            default:
              if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else {
                //return _createListView(context, snapshot);
                return Container(child: ItemListComponent(snapshot.data));
              }
          }
        });
  }
}
