
import 'package:flutter/cupertino.dart';

class Page<T> {
  int offset;
  int pageSize;
  int total;
  String queryId;
  List<T> content;

  Page({@required this.total, @required this.offset, @required this.pageSize, @required this.content, this.queryId});
}