import 'package:flutter/material.dart';
import 'package:poemobile/src/components/PoeModSelector.dart';
import 'package:poemobile/src/components/SocketForm.dart';
import 'package:poemobile/src/components/TextFieldSelect.dart';
import 'package:poemobile/src/di/Injector.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/PoePictureItem.dart';
import 'package:poemobile/src/entities/Stats.dart';
import 'package:poemobile/src/repositories/MarketRepository.dart';

class PoeFilterPage extends StatelessWidget {
  final MarketRepository marketRepository = Injector().marketRepository;
  final SocketForm socketForm = SocketForm();

  final PoeMarketQuery marketQuery;
  final Function(PoeMarketQuery query) onQueryChange;

  PoeFilterPage({@required this.marketQuery, @required this.onQueryChange});

  @override
  Widget build(BuildContext context) {
    this.socketForm.setFilter(this.marketQuery);
    return Scaffold(
      appBar: AppBar(
        title: Text("Market search filters"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              this.marketQuery.query.addDynamicFilter(socketForm.getSocketFilters());
              this.onQueryChange(this.marketQuery);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Socket Filters", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Divider(),
              socketForm,
              Divider(),
              Text("Item Type", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Divider(),
              TextFieldSelect<String>(
                dropdownItems: PoeItemParser.availableItemTypes,
                selectedValue: _getSelectedTypeValue(),
                onSelectedElement: (value) {
                  PoeMarketTypeFilter typeFilter = PoeMarketTypeFilter();
                  typeFilter.addFilter(PoeMarketTypeFilterSpecCategory(value));
                  this.marketQuery.query.addDynamicFilter(typeFilter);
                },
              ),
              Divider(),
              Text("Mods", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Divider(),
              _getFutureStats(),
              Divider(),
            ],
          )),
      ),
    );
  }

  String _getSelectedTypeValue() {
    if (this.marketQuery.query.filters == null) return null;

    final PoeDynamicFilter poeDynamicFilter = this.marketQuery.query
        .filters["type_filters"];

    if (poeDynamicFilter == null) return null;
    if (!(poeDynamicFilter is PoeMarketTypeFilter)) return null;

    final poeMarketTypeFilter = poeDynamicFilter as PoeMarketTypeFilter;

    if (poeMarketTypeFilter.filters == null) return null;
    final poeDynamicSubFilter = poeMarketTypeFilter.filters["category"];
    if (!(poeDynamicSubFilter is PoeMarketTypeFilterSpecCategory)) return null;
    final poeMarketTypeFilterSpecCategory = poeDynamicSubFilter as PoeMarketTypeFilterSpecCategory;
    return poeMarketTypeFilterSpecCategory.option;
  }

  Widget _getFutureStats() {
    return new FutureBuilder(
      future: this.marketRepository.fetchStats(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Container(
                child: Text('Loading...'), padding: EdgeInsets.all(12.0));
          default:
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else {
              final List<StatsEntry> statsEntries = (snapshot.data as List<Stats>).expand((stat) => stat.entries).toList();
              final initialEntries = this.marketQuery.query.stats.isNotEmpty ? this.marketQuery.query.stats.first.filters : [];
              return new Container(
                child: PoeModSelector(
                  statsEntries: statsEntries,
                  selectedEntries: initialEntries,
                  onChange: (List<PoeMarketStatsFilterSpec> updatedEntries) {
                    this.marketQuery.query.stats.clear();
                    this.marketQuery.query.stats.add(PoeMarketStatsFilter(
                      type: "and",
                      filters: updatedEntries,
                    ));
                  },
                ),
              );
            }
        }
      });
  }
}
