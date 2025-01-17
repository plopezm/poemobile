import 'package:flutter/cupertino.dart';

class PoeMarketQuery {
  PoeMarketQuerySpec query;
  PoeMarketQuerySort sort;

  PoeMarketQuery({@required this.query, @required this.sort});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonResult = {
      'query': query.toJson(),
      'sort': sort.toJson(),
    };
    return jsonResult;
  }

}

class PoeMarketQuerySpec {
  PoeMarketQueryStatus status;
  String term;
  String name;
  String type;
  List<PoeMarketStatsFilter> stats;
  Map<String, PoeDynamicFilter> filters;

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
    if (filters != null && filters.isNotEmpty) {
      json.putIfAbsent(
          "filters",
              () => filters.map((key, value) => MapEntry(key, value.toJson()))
      );
    }
    return json;
  }

  void addDynamicFilter(PoeDynamicFilter filter) {
    if (filter == null) return;
    if (filters == null) {
      this.filters = Map<String, PoeDynamicFilter>();
    }
    final PoeDynamicFilter existingFilter = filters[filter.getFilterId()];
    if (existingFilter != null) {
      filters.remove(filter.getFilterId());
    }
    filters.putIfAbsent(filter.getFilterId(), () => filter);
  }

  void removeDynamicFilter(String key) {
    if (filters == null) {
      return;
    }
    filters.remove(key);
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
  String text;
  bool disabled;

  PoeMarketStatsFilterSpec({this.id, this.value, this.disabled, this.text});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'disabled': disabled == null ? false : disabled
    };
    if (!value.isEmpty()) {
      result.putIfAbsent("value", () => value.toJson());
    }
    return result;
  }
}

class PoeMarketStatsFilterSpecValue {
  int min;
  int max;

  PoeMarketStatsFilterSpecValue({this.min, this.max});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (min>0) {
      result.putIfAbsent("min", () => min);
    }
    if (max>0) {
      result.putIfAbsent("max", () => max);
    }
    return result;
  }

  bool isEmpty() {
    return min == 0 && max == 0;
  }
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

abstract class PoeDynamicSubFilter {
  String getFilterId();
  Map<String, dynamic> toJson();
}

class PoeMarketSocketFilters extends PoeDynamicFilter {
  bool disabled;
  PoeMarketSocketFiltersSpec sockets;
  PoeMarketSocketFiltersSpec links;

  PoeMarketSocketFilters({this.sockets, this.links});

  @override
  String getFilterId() {
    return "socket_filters";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> filters = {};
    if (sockets != null) {
      filters.putIfAbsent("sockets", () => sockets.toJson());
    }
    if (links != null) {
      filters.putIfAbsent("links", () => links.toJson());
    }
    return {
      'disabled': disabled == null ? false : disabled,
      "filters": filters
    };
  }
}

class PoeMarketSocketFiltersSpec {
  int min;
  int max;
  int r;
  int g;
  int b;
  int w;

  PoeMarketSocketFiltersSpec({@required this.min, @required this.max,
    @required this.r, @required this.g, @required this.b, @required this.w});

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
    if (w > 0) {
      jsonResult.putIfAbsent("w", () => w);
    }
    return jsonResult;
  }
}

class PoeMarketTypeFilter extends PoeDynamicFilter {
  bool disabled;
  Map<String, PoeDynamicSubFilter> filters;
  PoeMarketTypeFilter({this.filters, this.disabled = false});

  @override
  String getFilterId() {
    return "type_filters";
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (filters != null && filters.isNotEmpty) {
      result.putIfAbsent(
          "filters",
              () => filters.map((key, value) => MapEntry(key, value.toJson()))
      );
    }
    return result;
  }

  void addFilter(PoeDynamicSubFilter filter) {
    if (filter == null) {
      return;
    }
    if (filters == null) {
      filters = {};
    }
    filters.putIfAbsent(filter.getFilterId(), () => filter);
  }

}

class PoeMarketTypeFilterSpecCategory extends PoeDynamicSubFilter {
  String option;

  PoeMarketTypeFilterSpecCategory(this.option);

  Map<String, dynamic> toJson() {
    return {
      "option": option
    };
  }

  @override
  String getFilterId() {
    return "category";
  }

}