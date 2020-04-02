
import 'package:flutter/material.dart';
import 'package:poemobile/src/components/DataTable.dart';
import 'package:poemobile/src/entities/MarketResult.dart';

const Map<String, MaterialColor> colors = {
  "I": Colors.blue,
  "D": Colors.green,
  "S": Colors.red
};

const Map<String, String> currencyMap = {
  "jew": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyRerollSocketNumbers.png?w=1&h=1&scale=1",
  "chance": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyUpgradeRandomly.png?w=1&h=1&scale=1",
  "alch": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyUpgradeToRare.png?w=1&h=1&scale=1",
  "chaos": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyRerollRare.png?w=1&h=1&scale=1&v=c60aa876dd6bab31174df91b1da1b4f9",
  "chisel": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyMapQuality.png?w=1&h=1&scale=1",
  "exa": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyAddModToRare.png?w=1&h=1&scale=1",
  "chrom": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyRerollSocketColours.png?w=1&h=1&scale=1",
  "alt": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyRerollMagic.png?w=1&h=1&scale=1",
  "blessed": "https://web.poecdn.com/image/Art/2DItems/Currency/CurrencyImplicitMod.png?w=1&h=1&scale=1&v=472eeef04846d8a25d65b3d4f9ceecc8"
};

class PoeItemListComponent extends StatelessWidget {

  final List<ItemSearchResult> result;
  final void Function() onLastItemReached;

  const PoeItemListComponent(this.result, this.onLastItemReached);

  @override
  Widget build(BuildContext context) {
    return DynamicDataTableComponent<ItemSearchResult>(
      tableHeaders: <String>["Price", "Sockets", "Item", "Name", "Requirements", "Properties", "Mods"],
      rows: this.result,
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
      onLastElementReached: this.onLastItemReached,
    );
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
    if (listingPrice == null) {
      return Text("Not found");
    }
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