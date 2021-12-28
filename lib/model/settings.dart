/*
congress_fahrplan
This is the dart file that containing the Settings class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2021 Benjamin Schilling
*/

import 'dart:convert';
import 'dart:io';

import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/utilities/fahrplan_fetcher.dart';
import 'package:congress_fahrplan/utilities/file_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings {
  int loadFullFahrplan = 0;

  Settings({required this.loadFullFahrplan});

  static Future<Settings> restoreSettingsFromFile() async {
    File settingsFile;
    if (await FileStorage.settingsFileAvailable) {
      settingsFile = await FileStorage.localSettingsFile;
      String settingsJsonString = await settingsFile.readAsString();
      if (settingsJsonString != '') {
        return Settings.fromJson(json.decode(settingsJsonString));
      }
    }
    return Settings(loadFullFahrplan: 0);
  }

  factory Settings.fromJson(Map json) {
    return Settings(
      loadFullFahrplan: json['loadfullfahrplan'],
    );
  }

  bool getLoadFullFahrplan() {
    if (loadFullFahrplan > 0) {
      return true;
    } else {
      return false;
    }
  }

  void setLoadFullFahrplan(bool value, BuildContext context) {
    if (loadFullFahrplan != (value == true ? 1 : 0)) {
      loadFullFahrplan = value == true ? 1 : 0;
      writeFile();

      var favorites = Provider.of<FavoriteProvider>(context, listen: false);
      favorites.notifyMainListeners();
      favorites.futureFahrplan = FahrplanFetcher.fetchFahrplan();
    }
  }

  void writeFile() {
    FileStorage.writeSettingsFile('{"loadfullfahrplan": $loadFullFahrplan}');
  }
}
