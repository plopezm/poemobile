import 'package:flutter/material.dart';
import 'package:poemobile/src/components/data_table.dart';
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
              return new Text('Loading...');
            default:
              if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else {
                //return _createListView(context, snapshot);
                return DynamicDataTableComponent<ItemSearchResult>(
                  tableHeaders: <String>["Price", "Sockets", "Item", "Name", "Requirements", "Properties", "Mods"],
                  rows: snapshot.data,
                  onRowFormat: (element) => <DataCell>[
                    DataCell(_getPrice(element.listing.price)),
                    DataCell(SingleChildScrollView(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _getSockets(element.item.sockets)))),
                    DataCell(SingleChildScrollView(child: Image.network(element.item.icon, scale: 1.4))),
                    DataCell(
                      Wrap(children: <Widget>[
                        element.item.corrupted != null ? Text("Corrupted", style: TextStyle(color: Colors.red),) : Text(""),
                        Text("${element.item.typeLine} ${element.item.name}")
                      ], direction: Axis.vertical)
                    ),
                    DataCell(SingleChildScrollView(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getProperties(element.item.requirements)))),
                    DataCell(SingleChildScrollView(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getProperties(element.item.properties)))),
                    DataCell(SingleChildScrollView(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _getMods(element.item.explicitMods))))
                  ],
                );
              }
          }
        });
  }

  List<Widget> _getMods(List<dynamic> mods) {
    if (mods == null || mods.isEmpty) {
      return <Widget>[Text("-")];
    }
    return mods.map((e) => Text(e.trim())).toList();
  }

  List<Widget> _getProperties(List<ItemProperty> properties) {
    if (properties.isEmpty) {
      return <Widget>[Text("-")];
    }
    return properties
        .map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("${e.name.trim()}: "),
                Text("${e.values.isEmpty ? "" : e.values[0][0].toString().trim()}")
              ],
            ))
        .toList();
  }

  Widget _getPrice(ListingPrice listingPrice) {
    final String imageUrl = currencyMap[listingPrice.currency];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        imageUrl == null ? Text(listingPrice.currency) : Image.network(imageUrl),
        Text("${listingPrice.amount}x"),
      ],
    );
  }

  List<Widget> _getSockets(List<ItemSockets> sockets) {
    Map<int, List<ItemSockets>> socketsMap = {};

    sockets.forEach((element) {
      List<ItemSockets> groupList = socketsMap[element.group];
      if (groupList == null) {
        socketsMap.putIfAbsent(element.group, () => [element]);
      } else {
        groupList.add(element);
      }
    });

    return socketsMap.keys.map((e) => Column(
      children: [Row(children: socketsMap[e].map((e) => Icon(Icons.swap_horizontal_circle, color: colors[e.attr])).toList())],
    )).toList();
  }
}

const Map<String, MaterialColor> colors = {
  "I": Colors.blue,
  "D": Colors.green,
  "S": Colors.red
};

const Map<String, String> currencyMap = {
  "jew": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyRerollSocketNumbers.png?w=1&h=1&scale=1",
  "chance": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyUpgradeRandomly.png?w=1&h=1&scale=1",
  "alch": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyUpgradeToRare.png?w=1&h=1&scale=1",
  "chaos": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyRerollRare.png?w=1&h=1&scale=1",
  "chisel": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyMapQuality.png?w=1&h=1&scale=1",
  "exa": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyAddModToRare.png?w=1&h=1&scale=1"
};
