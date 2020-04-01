import 'package:flutter/material.dart';

class DynamicDataTableComponent<T> extends StatelessWidget {
  final List<String> tableHeaders;
  final List<T> rows;
  final List<DataCell> Function(T element) onRowFormat;
  final void Function() onLastElementReached;

  const DynamicDataTableComponent(
      {@required this.tableHeaders,
      @required this.rows,
      @required this.onRowFormat,
      this.onLastElementReached});

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (this.onLastElementReached == null) {
        return;
      }
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        print("Last item reached!!");
        this.onLastElementReached();
      }
    });

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: new DataTable(
            columnSpacing: 20.0,
            dataRowHeight: 100,
            columns: _getHeaders(),
            rows: _getRows(),
          ),
        ));
  }

  List<DataColumn> _getHeaders() {
    return this.tableHeaders.map((element) {
      return DataColumn(label: Text(element), numeric: false);
    }).toList();
  }

  List<DataRow> _getRows() {
    List<DataRow> rows = [];
    this.rows.forEach((element) {
      List<DataCell> dataCells = this.onRowFormat(element);
      if (dataCells.isEmpty) {
        return;
      }
      rows.add(DataRow(cells: dataCells));
    });
    return rows;
  }
}
