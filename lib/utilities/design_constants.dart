/*
congress_fahrplan
This is the dart file contains the DesignConstants class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';

class DesignConstants {
  static Color darkPrimaryColor = Color(0xFF303F9F);
  static Color lightPrimaryColor = Color(0xFFC5CAE9);
  static Color primaryColor = Color(0xFF3F51B5);
  static Color textIcons = Color(0xFFFFFFFF);
  static Color accentColor = Color(0xFF607D8B);
  static Color primaryText = Color(0xFF212121);
  static Color secondaryText = Color(0xFF757575);
  static Color dividerColor = Color(0xFFBDBDBD);

  static TextStyle getDefaultTextStyle() {
    return new TextStyle(color: textIcons);
  }

  static TextStyle getHeadlineTextStyle() {
    return new TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: textIcons);
  }
}
