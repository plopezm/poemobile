import 'package:flutter/material.dart';
import 'package:poemobile/src/components/socket_form.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';

class PoeFilterPage extends StatelessWidget {
  final PoeMarketQuery query;
  final Function(PoeMarketQuery query) onQueryChange;

  final SocketForm socketForm = SocketForm();

  PoeFilterPage({@required this.query, @required this.onQueryChange});

  @override
  Widget build(BuildContext context) {
    this.socketForm.setFilter(this.query);
    return Scaffold(
      appBar: AppBar(
        title: Text("Market search filters"),
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Socket Filters", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Divider(),
              socketForm,
              Divider(),
            ],
          ),
      ),
      floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                query.query.addDynamicFilter(socketForm.getSocketFilters());
                this.onQueryChange(query);
                Navigator.pop(context);
              },
            ),
          ]),
    );
  }
}
