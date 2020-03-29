
import 'package:flutter/material.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/Stats.dart';

class PoeModSelector extends StatefulWidget {

  final List<PoeMarketStatsFilterSpec> selectedEntries;
  final List<StatsEntry> statsEntries;
  final Function(List<PoeMarketStatsFilterSpec> statsEntries) onChange;

  PoeModSelector({@required this.statsEntries, @required this.onChange, this.selectedEntries});

  @override
  State<StatefulWidget> createState() {
    return _PoeModSelectorState();
  }
}

class _PoeModSelectorState extends State<PoeModSelector> {
  final TextEditingController searcher = new TextEditingController(text: "");
  final TextEditingController min = new TextEditingController(text: "");
  final TextEditingController max = new TextEditingController(text: "");
  List<PoeMarketStatsFilterSpec> selectedEntries = [];

  @override
  void initState() {
    if (widget.selectedEntries != null) {
      // TODO: fill state list
      this.selectedEntries.clear();
      widget.selectedEntries.forEach((element) {
        this.selectedEntries.add(element);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.onChange(this.selectedEntries);

    final results = widget.statsEntries.where((entry) => searcher.text != "" && entry.text.toLowerCase().contains(searcher.text.toLowerCase())).toList();
    return Column(
      children: <Widget>[
        _getSelectedMods(),
        Row(
          children: <Widget>[
            Expanded(child: TextField(
              decoration: InputDecoration(labelText: "Type a mod"),
              controller: searcher,
              onChanged: (value) {
                this.setState(() { });
              },
            )),
          ],
        ),
        ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 35.0,
            maxHeight: 200.0,
          ),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              StatsEntry entry = results[index];
              return ListTile(
                title: Text("${entry.text}"),
                onTap: () {
                  print("${entry.id}");
                  setState(() {
                    this.selectedEntries.add(PoeMarketStatsFilterSpec(
                        id: entry.id,
                        text: entry.text,
                        value: PoeMarketStatsFilterSpecValue(
                          min: 0,
                          max: 0,
                        )
                    ));
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getSelectedMods() {
    return Wrap(
      children: this.selectedEntries.map((entry) {
          TextEditingController min = TextEditingController(text: "${entry.value.min}");
          TextEditingController max = TextEditingController(text: "${entry.value.max}");

          return Row(children: [
            Chip(
              label: SizedBox(
                  child: Text(entry.text, overflow: TextOverflow.fade, style: TextStyle(fontSize: 11)),
                  width: 240
              ),
              onDeleted: () {
                setState(() {
                  this.selectedEntries.remove(entry);
                });
              },
            ),
            Expanded(child: SizedBox()),
            SizedBox(width: 40,child: TextField(
              controller: min,
              decoration: InputDecoration(labelText: "Min"),
              onChanged: (value) {
                try {
                  entry.value.min = int.parse(value);
                } catch(e) {
                  entry.value.min = 0;
                }
              }
            )),
            SizedBox(width: 40,child: TextField(
              controller: max,
              decoration: InputDecoration(labelText: "Max"),
              onChanged: (value) {
                try {
                  entry.value.max = int.parse(value);
                } catch(e) {
                  entry.value.max = 0;
                }
              },
            ))
          ]);
      }).toList(),
    );
  }
}