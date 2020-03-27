import 'package:flutter/cupertino.dart';

class PoeMarketQuery {
  PoeMarketQuerySpec query;
  Map<String, PoeDynamicFilter> filters;
  PoeMarketQuerySort sort;

  PoeMarketQuery({@required this.query, @required this.sort});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonResult = {
      'query': query.toJson(),
      'sort': sort.toJson(),
    };
    if (filters != null && filters.isNotEmpty) {
      jsonResult.putIfAbsent(
          "filters",
          () => filters.map((key, value) => MapEntry(key, value.toJson()))
      );
    }
    return jsonResult;
  }

  void addDynamicFilter(PoeDynamicFilter filter) {
    filters.putIfAbsent(filter.getFilterId(), () => filter);
  }
}

class PoeMarketQuerySpec {
  PoeMarketQueryStatus status;
  String term;
  String name;
  String type;
  List<PoeMarketStatsFilter> stats;

  PoeMarketQuerySpec({this.status, this.term, this.name, this.type, this.stats});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'status': status.toJson(),
      'stats': stats.map((e) => e.toJson()).toList(),
    };
    if (name != null && name.isNotEmpty) {
      json.putIfAbsent('name', () => name);
    }
    if (type != null && name.isNotEmpty) {
      json.putIfAbsent('type', () => type);
    }
    if (term != null && term.isNotEmpty) {
      json.putIfAbsent('term', () => term);
    }
    return json;
  }
}

class PoeMarketStatsFilter {
  String type;
  List<PoeMarketStatsFilterSpec> filters;

  PoeMarketStatsFilter({this.type, this.filters});

  Map<String, dynamic> toJson() => {
        'type': type,
        'filters': filters.map((e) => e.toJson()).toList(),
      };
}

class PoeMarketStatsFilterSpec {
  String id;
  PoeMarketStatsFilterSpecValue value;
  bool disabled;

  PoeMarketStatsFilterSpec({this.id, this.value, this.disabled});

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value.toJson(),
      };
}

class PoeMarketStatsFilterSpecValue {
  int min;
  int max;

  PoeMarketStatsFilterSpecValue({this.min, this.max});

  Map<String, dynamic> toJson() => {
        'min': min,
        'max': max,
      };
}

class PoeMarketQuerySort {
  String price;

  PoeMarketQuerySort({this.price});

  Map<String, dynamic> toJson() => {
        'price': price,
      };
}

class PoeMarketQueryStatus {
  String option;

  PoeMarketQueryStatus({this.option});

  Map<String, dynamic> toJson() => {
        'option': option,
      };
}

/// ***************************
///     Dynamic filters
/// ***************************

abstract class PoeDynamicFilter {
  String getFilterId();
  Map<String, dynamic> toJson();
}

class PoeMarketSocketFilters extends PoeDynamicFilter {
  bool disabled;
  PoeMarketSocketFiltersSpec sockets;

  @override
  String getFilterId() {
    return "socket_filters";
  }

  Map<String, dynamic> toJson() {
    return {
      'disabled': disabled,
      "filters": {
        "sockets": sockets.toJson()
      }
    };
  }
}

class PoeMarketSocketFiltersSpec {
  int min;
  int max;
  int r;
  int g;
  int b;

  PoeMarketSocketFiltersSpec({@required this.min, @required this.max,
    @required this.r, @required this.g, @required this.b});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonResult = {};
    if (min > 0){
      jsonResult.putIfAbsent("min", () => min);
    }
    if (max > 0){
      jsonResult.putIfAbsent("max", () => max);
    }
    if (r > 0){
      jsonResult.putIfAbsent("r", () => r);
    }
    if (g > 0){
      jsonResult.putIfAbsent("g", () => g);
    }
    if (b > 0){
      jsonResult.putIfAbsent("b", () => b);
    }
    return jsonResult;
  }
}