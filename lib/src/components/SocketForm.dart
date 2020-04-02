
import 'package:flutter/material.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';

class SocketForm extends StatelessWidget {
  final TextEditingController socketRController = TextEditingController(text: "0");
  final TextEditingController socketGController = TextEditingController(text: "0");
  final TextEditingController socketBController = TextEditingController(text: "0");
  final TextEditingController socketWController = TextEditingController(text: "0");
  final TextEditingController socketMinController = TextEditingController(text: "0");
  final TextEditingController socketMaxController = TextEditingController(text: "0");
  
  final TextEditingController linkRController = TextEditingController(text: "0");
  final TextEditingController linkGController = TextEditingController(text: "0");
  final TextEditingController linkBController = TextEditingController(text: "0");
  final TextEditingController linkWController = TextEditingController(text: "0");
  final TextEditingController linkMinController = TextEditingController(text: "0");
  final TextEditingController linkMaxController = TextEditingController(text: "0");

  SocketForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("Sockets:"),
            Expanded(child: SizedBox()),
            SizedBox(width: 25, child: TextField(keyboardType: TextInputType.number, controller: socketRController, decoration: InputDecoration(labelText: 'R', labelStyle: TextStyle(color: Colors.red)))),
            SizedBox(width: 25, child: TextField(keyboardType: TextInputType.number, controller: socketGController, decoration: InputDecoration(labelText: 'G', labelStyle: TextStyle(color: Colors.green)))),
            SizedBox(width: 25, child: TextField(keyboardType: TextInputType.number, controller: socketBController, decoration: InputDecoration(labelText: 'B', labelStyle: TextStyle(color: Colors.blue)))),
            SizedBox(width: 25, child: TextField(keyboardType: TextInputType.number, controller: socketWController, decoration: InputDecoration(labelText: 'W'))),
            SizedBox(width: 35, child: TextField(keyboardType: TextInputType.number, controller: socketMinController, decoration: InputDecoration(labelText: 'Min'))),
            SizedBox(width: 35, child: TextField(keyboardType: TextInputType.number, controller: socketMaxController, decoration: InputDecoration(labelText: 'Max'))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("Links:"),
            Expanded(child: SizedBox()),
            SizedBox(width: 25, child: TextField(keyboardType: TextInputType.number, controller: linkRController, decoration: InputDecoration(labelText: 'R', labelStyle: TextStyle(color: Colors.red)))),
            SizedBox(width: 25, child: TextField(keyboardType: TextInputType.number, controller: linkGController, decoration: InputDecoration(labelText: 'G', labelStyle: TextStyle(color: Colors.green)))),
            SizedBox(width: 25, child: TextField(keyboardType: TextInputType.number, controller: linkBController, decoration: InputDecoration(labelText: 'B', labelStyle: TextStyle(color: Colors.blue)))),
            SizedBox(width: 25, child: TextField(keyboardType: TextInputType.number, controller: linkWController, decoration: InputDecoration(labelText: 'W'))),
            SizedBox(width: 35, child: TextField(keyboardType: TextInputType.number, controller: linkMinController, decoration: InputDecoration(labelText: 'Min'))),
            SizedBox(width: 35, child: TextField(keyboardType: TextInputType.number, controller: linkMaxController, decoration: InputDecoration(labelText: 'Max'))),
          ],
        )
      ],
    );
  }

  void setFilter(PoeMarketQuery marketQuery) {
    if (marketQuery.query.filters == null || !marketQuery.query.filters.containsKey("socket_filters")) {
      return;
    }
    final PoeMarketSocketFilters socketFilters = marketQuery.query.filters["socket_filters"] as PoeMarketSocketFilters;
    if (socketFilters.sockets != null) {
      socketRController.text = socketFilters.sockets.r.toString();
      socketGController.text = socketFilters.sockets.g.toString();
      socketBController.text = socketFilters.sockets.b.toString();
      socketWController.text = socketFilters.sockets.w.toString();
      socketMinController.text = socketFilters.sockets.min.toString();
      socketMaxController.text = socketFilters.sockets.max.toString();
    }

    if (socketFilters.links != null) {
      linkRController.text = socketFilters.links.r.toString();
      linkGController.text = socketFilters.links.g.toString();
      linkBController.text = socketFilters.links.b.toString();
      linkWController.text = socketFilters.links.w.toString();
      linkMinController.text = socketFilters.links.min.toString();
      linkMaxController.text = socketFilters.links.max.toString();
    }
  }

  PoeMarketSocketFilters getSocketFilters() {
    PoeMarketSocketFiltersSpec sockets;
    PoeMarketSocketFiltersSpec links;

    if (!(socketRController.text == "0"
        && socketGController.text == "0"
        && socketBController.text == "0"
        && socketWController.text == "0"
        && socketMinController.text == "0"
        && socketMaxController.text == "0")){
      sockets = PoeMarketSocketFiltersSpec(
          r: int.parse(socketRController.text),
          g: int.parse(socketGController.text),
          b: int.parse(socketBController.text),
          w: int.parse( socketWController.text),
          min: int.parse(socketMinController.text),
          max: int.parse(socketMaxController.text)
      );
    }

    if (!( linkRController.text == "0"
        && linkGController.text == "0"
        && linkBController.text == "0"
        && linkWController.text == "0"
        && linkMinController.text == "0"
        && linkMaxController.text == "0")){
      links = PoeMarketSocketFiltersSpec(
          r: int.parse(linkRController.text),
          g: int.parse(linkGController.text),
          b: int.parse(linkBController.text),
          w: int.parse(linkWController.text),
          min: int.parse(linkMinController.text),
          max: int.parse(linkMaxController.text)
      );
    }
    if (sockets == null && links == null) {
      return null;
    }
    return PoeMarketSocketFilters(
      sockets: sockets,
      links: links
    );
  }

}