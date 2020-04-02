import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:poemobile/src/di/Injector.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/Stats.dart';
import 'package:poemobile/src/repositories/MarketRepository.dart';

class PoePictureItem {
  String title;
  String base;
  String category;
  List<PoeMarketStatsFilterSpec> mods;
}

class PoeItemParser {
  final MarketRepository marketRepository = Injector().marketRepository;
  static final PoeItemParser _poeItemParser = PoeItemParser.getInstance();

  factory PoeItemParser() {
    return _poeItemParser;
  }

  PoeItemParser.getInstance();

  Future<PoePictureItem> parseImage(VisionText visionTexts) async {
    List<Stats> statsEntries = await marketRepository.fetchStats();
    return _fillItem(visionTexts, statsEntries);
  }

  PoePictureItem _fillItem(VisionText visionTexts, List<Stats> statsEntries) {
    PoePictureItem poePictureItem = PoePictureItem();
    poePictureItem.mods = [];
    int i = 0;
    if (visionTexts == null || visionTexts.blocks == null) return null;
    visionTexts.blocks.forEach((visionText) {
      if (visionText.lines == null) return;
      visionText.lines.forEach((line) {
        print(line.text);
        if (this._isIgnorableProperty(line.text)) {
          i++;
          return;
        }
        switch (i) {
          case 0:
            poePictureItem.title = line.text;
            break;
          case 1:
            poePictureItem.base = line.text;
            break;
          case 2:
            poePictureItem.category = _getItemType(line.text);
            break;
          default:
            PoeMarketStatsFilterSpec mod = _parseModString(line.text, statsEntries);
            if (mod != null) {
              poePictureItem.mods.add(mod);
            }
        }
        i++;
      });
    });
    if (poePictureItem.category == null || poePictureItem.category.isEmpty) {
      poePictureItem.category = _getItemTypeByBase(poePictureItem.base == null ? poePictureItem.title : poePictureItem.base);
    }
    return poePictureItem;
  }

  bool _isIgnorableProperty(String line) {
    if (line == null) {
      return true;
    }
    return line.toLowerCase().contains("quality") ||
        line.toLowerCase().contains("armour") ||
        line.toLowerCase().contains("evasion rating") ||
        line.toLowerCase().contains("requires level") ||
        line.toLowerCase().contains("stack size");
  }

  PoeMarketStatsFilterSpec _parseModString(String modString, List<Stats> statsEntries) {
    final intRegex = RegExp(r'\d+', multiLine: true);
    final List<String> stringValues =
    intRegex.allMatches(modString).map((m) => m.group(0)).toList();
    final String name = "${modString.replaceAll(RegExp(r'\+*\d+'), "#")}";
    final StatsEntry foundEntry = _findStatsIdByName(name, statsEntries);
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

  StatsEntry _findStatsIdByName(String name, List<Stats> statsEntries) {
    List<StatsEntry> found = statsEntries
        .expand((element) => element.entries)
        .where((element) => element.text.toLowerCase() == name.toLowerCase()).toList();
    if (found.isEmpty) {
      return null;
    }
    return found.first;
  }

  String _getItemTypeByBase(String base) {
    String lcb = base.toLowerCase();
    if (lcb.contains("belt") || lcb.contains("sash")) {
      return "accessory.belt";
    } else if (lcb.contains("gloves") || lcb.contains("mitts")) {
      return "armour.gloves";
    } else if (lcb.contains("quiver")) {
      return "armour.quiver";
    } else if (lcb.contains("hat") || lcb.contains("helmet") ||
        lcb.contains("mask") || lcb.contains("tricorne") ||
        lcb.contains("cage") || lcb.contains("pelt")) {
        return "armour.helmet";
    } else if (lcb.contains("shield") || lcb.contains("buckler") ||
        lcb.contains("bundle")) {
      return "armour.shield";
    } else if (lcb.contains("ring")) {
      return "accessory.ring";
    } else if (lcb.contains("boots") || lcb.contains("slippers") ||
        lcb.contains("greaves")) {
      return "armour.boots";
    } else if (lcb.contains("talisman") || lcb.contains("amulet")) {
      return "accessory.amulet";
    } else {
        return "";
    }
  }

  static final List<MapEntry<String, String>> availableItemTypes = [
    MapEntry<String,String>("Helmet", "armour.helmet"),
    MapEntry<String,String>("Chest", "armour.chest"),
    MapEntry<String,String>("Belt", "accessory.belt"),
    MapEntry<String,String>("Boots", "armour.boots"),
    MapEntry<String,String>("Gloves", "armour.gloves"),
    MapEntry<String,String>("Ring", "accessory.ring"),
    MapEntry<String,String>("Amulet", "accessory.amulet"),
    MapEntry<String,String>("Shield", "armour.shield"),
    MapEntry<String,String>("Quiver", "armour.quiver"),
    MapEntry<String,String>("Bow", "weapon.bow"),
    MapEntry<String,String>("Claw", "weapon.claw"),
    MapEntry<String,String>("Sceptre", "weapon.sceptre"),
    MapEntry<String,String>("Staff", "weapon.staff"),
    MapEntry<String,String>("One Handed Axe", "weapon.oneaxe"),
    MapEntry<String,String>("One Handed Mace", "weapon.onemace"),
    MapEntry<String,String>("One Handed Sword", "weapon.onesword"),
    MapEntry<String,String>("Two Handed Axe", "weapon.twoaxe"),
    MapEntry<String,String>("Two Handed Mace", "weapon.twomace"),
    MapEntry<String,String>("Two Handed Sword", "weapon.twosword"),
  ];

  String _getItemType(String type) {
    String lct = type.toLowerCase();
    switch(lct) {
      case "bow":
        return "weapon.bow";
      case "claw":
        return "weapon.claw";
      case "one handed axe":
        return "weapon.oneaxe";
      case "one handed mace":
        return "weapon.onemace";
      case "one handed sword":
        return "weapon.onesword";
      case "sceptre":
        return "weapon.sceptre";
      case "staff":
        return "weapon.staff";
      case "two handed axe":
        return "weapon.twoaxe";
      case "two handed mace":
        return "weapon.twomace";
      case "two handed sword":
        return "weapon.twosword";
      case "fishing rod":
        return "weapon.rod";
      default:
        return "";
    }
  }

}