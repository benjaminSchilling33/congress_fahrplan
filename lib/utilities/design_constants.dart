import 'package:flutter/material.dart';

class DesignConstants {
  static Color primarySwatch = Colors.grey;
  static Color canvasColor = Color.fromRGBO(40, 40, 40, 1);
  static Color accentColor = Colors.grey;

  static TextStyle getDefaultTextStyle() {
    return new TextStyle(color: Colors.grey);
  }

  static TextStyle getHeadlineTextStyle() {
    return new TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey);
  }
}
