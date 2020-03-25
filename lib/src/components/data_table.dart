import 'package:flutter/material.dart';

class DynamicDataTableComponent<T> extends StatelessWidget {
  final List<String> tableHeaders;
  final List<T> rows;
  final List<DataCell> Function(T element) onRowFormat;

  const DynamicDataTableComponent(
      {@required this.tableHeaders,
      @required this.rows,
      @required this.onRowFormat});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
