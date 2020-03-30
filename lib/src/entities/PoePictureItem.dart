import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/Stats.dart';

class PoePictureItem {
  final List<Stats> _statsEntries;

  String title;
  String subtitle;
  List<PoeMarketStatsFilterSpec> mods;

  PoePictureItem(this._statsEntries, VisionText visionTexts) {
    this.mods = [];
    int i = 0;
    if (visionTexts == null || visionTexts.blocks == null) return;
    visionTexts.blocks.forEach((visionText) {
      if (visionText.lines == null) return;
      if (visionText.lines.length < 3 || !this.isIgnorableProperty(visionText.text)) {
        return;
      }
      visionText.lines.forEach((line) {
        print(line.text);
        if (this.isIgnorableProperty(line.text)) {
          i++;
          return;
        }
        switch (i) {
          case 0:
            this.title = line.text;
            break;
          case 1:
            this.subtitle = line.text;
            break;
          default:
            PoeMarketStatsFilterSpec mod = parseModString(line.text);
            if (mod != null) {
              this.mods.add(mod);
            }
        }
        i++;
      });
    });
  }

  bool isIgnorableProperty(String line) {
    if (line == null) {
      return true;
    }
    return line.toLowerCase().contains("quality") ||
        line.toLowerCase().contains("armour") ||
        line.toLowerCase().contains("evasion rating") ||
        line.toLowerCase().contains("requires level") ||
        line.toLowerCase().contains("stack size");
  }

  PoeMarketStatsFilterSpec parseModString(String modString) {
    final intRegex = RegExp(r'\d+', multiLine: true);
    final List<String> stringValues =
        intRegex.allMatches(modString).map((m) => m.group(0)).toList();
    final String name = "${modString.replaceAll(RegExp(r'\+*\d+'), "#")}";
    final StatsEntry foundEntry = _findStatsIdByName(name);
    if (foundEntry == null) {
      return null;
    }
    PoeMarketStatsFilterSpec spec = PoeMarketStatsFilterSpec(
        id:  foundEntry.id,
        text: foundEntry.text,
        disabled: false,
        value: PoeMarketStatsFilterSpecValue(min: 0, max: 0));

    if (stringValues.isEmpty) {
      return spec;
    }
    try {
      spec.value.min = int.parse(stringValues[0]);
    } catch (e) {}
    if (stringValues.length > 1) {
      try {
        spec.value.max = int.parse(stringValues[1]);
      } catch (e) {}
    }
    return spec;
  }


  StatsEntry _findStatsIdByName(String name) {
    List<StatsEntry> found = this._statsEntries
        .expand((element) => element.entries)
        .where((element) => element.text.toLowerCase() == name.toLowerCase()).toList();
    if (found.isEmpty) {
      return null;
    }
    return found.first;
  }
}
