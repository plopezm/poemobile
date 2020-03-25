import 'package:flutter/cupertino.dart';

class PoeMarketQuery {
  PoeMarketQuerySpec query;
  PoeMarketQuerySort sort;

  PoeMarketQuery({@required this.query, @required this.sort});

  Map<String, dynamic> toJson() => {
        'query': query.toJson(),
        'sort': sort.toJson(),
      };
}

class PoeMarketQuerySpec {
  PoeMarketQueryStatus status;
  String term;
  String name;
  String type;
  List<PoeMarketFilter> stats;

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

class PoeMarketFilter {
  String type;
  List<PoeMarketFilterSpec> filters;

  PoeMarketFilter({this.type, this.filters});

  Map<String, dynamic> toJson() => {
        'type': type,
        'filters': filters.map((e) => e.toJson()).toList(),
      };
}

class PoeMarketFilterSpec {
  String id;
  PoeMarketFilterSpecValue value;
  bool disabled;

  PoeMarketFilterSpec({this.id, this.value, this.disabled});

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value.toJson(),
      };
}

class PoeMarketFilterSpecValue {
  int min;
  int max;

  PoeMarketFilterSpecValue({this.min, this.max});

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
