
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class PoePictureItem {

  String title;
  String subtitle;
  List<String> mods;

  PoePictureItem(VisionText visionTexts) {
    this.mods = [];
    int i = 0;
    if (visionTexts == null || visionTexts.blocks == null) return;
    visionTexts.blocks.forEach((visionText) {
      if (visionText.lines == null) return;
      visionText.lines.forEach((line) {
        print(line.text);
        if (this.isIgnorableProperty(line.text)) {
          i++;
          return;
        }
        switch(i) {
          case 0:
            this.title = line.text;
            break;
          case 1:
            this.subtitle = line.text;
            break;
          default:
            this.mods.add(line.text);
        }
        i++;
      });
    });
  }

  bool isIgnorableProperty(String line) {
    if (line == null) {
      return true;
    }
    return line.toLowerCase().contains("quality")
        || line.toLowerCase().contains("armour")
        || line.toLowerCase().contains("evasion rating")
        || line.toLowerCase().contains("requires level")
        || line.toLowerCase().contains("stack size");

  }
}