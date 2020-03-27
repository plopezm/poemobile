
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class PoePictureItem {

  String title;
  String subtitle;

  PoePictureItem(VisionText visionTexts) {
    int i = 0;
    if (visionTexts == null || visionTexts.blocks == null) return;
    visionTexts.blocks.forEach((visionText) {
      if (visionText.lines == null) return;
      visionText.lines.forEach((line) {
        print(line.text);
        switch(i) {
          case 0:
            this.title = line.text;
            break;
          case 1:
            if (line.text.toLowerCase().contains("stack size")) {
              i++;
              return;
            }
            this.subtitle = line.text;
            break;
        }
        i++;
      });
    });
  }
}