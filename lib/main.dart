import 'package:flutter/material.dart';
import 'package:poemobile/src/app.dart';
import 'package:poemobile/src/di/Injector.dart';

void main() {
  Injector.configure(Environment.PROD);
  runApp(PoeMobileApp());
}
