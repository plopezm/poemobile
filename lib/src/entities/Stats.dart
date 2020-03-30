
class Stats {
  String label;
  List<StatsEntry> entries;

  Stats({this.label, this.entries});

  factory Stats.fromJson(Map<String, dynamic> parsedJson) {
    return Stats(
      label: parsedJson["label"],
      entries: StatsEntry.listFromJson(parsedJson["entries"])
    );
  }

  static List<Stats> listFromJson(List<dynamic> parsedJson) {
    return parsedJson.map((jsonStat) => Stats.fromJson(jsonStat)).toList();
  }
}

class StatsEntry {
  String id;
  String text;
  String type;

  StatsEntry({this.id, this.text, this.type});

  factory StatsEntry.fromJson(Map<String, dynamic> parsedJson) {
    return StatsEntry(
      id: parsedJson["id"],
      text: parsedJson["text"],
      type: parsedJson["type"]
    );
  }

  static List<StatsEntry> listFromJson(List<dynamic> parsedJson) {
    return parsedJson.map((jsonStat) => StatsEntry.fromJson(jsonStat)).toList();
  }
}