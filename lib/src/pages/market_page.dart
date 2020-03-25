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
                  tableHeaders: <String>["Price", "Item", "Name", "Properties"],
                  rows: snapshot.data,
                  onRowFormat: (element) => <DataCell>[
                    DataCell(_getPrice(element.listing.price)),
                    DataCell(Image.network(element.item.icon, scale: 1.4)),
                    DataCell(
                      Wrap(children: <Widget>[
                        Text("${element.item.typeLine} ${element.item.name}")
                      ], direction: Axis.vertical)
                    ),
                    DataCell(Column(
                        children: _getProperties(element.item.properties)))
                  ],
                );
              }
          }
        });
  }

  List<Widget> _getProperties(List<ItemProperty> properties) {
    if (properties.isEmpty) {
      return <Widget>[Text("no properties")];
    }
    return properties
        .map((e) => Row(
              children: <Widget>[
                Text("${e.name}: "),
                Text("${e.values.join(",")}")
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
}

const Map<String, String> currencyMap = {
  "jew": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyRerollSocketNumbers.png?w=1&h=1&scale=1",
  "chance": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyUpgradeRandomly.png?w=1&h=1&scale=1",
  "alch": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyUpgradeToRare.png?w=1&h=1&scale=1",
  "chaos": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyRerollRare.png?w=1&h=1&scale=1"
};
