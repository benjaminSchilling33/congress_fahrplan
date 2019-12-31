/*
congress_fahrplan
This is the dart file containing the FileStorage class needed to load the cached Fahrplan and the favorites.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<bool> get dataFileAvailable async {
    final path = await localPath;
    return File('$path/data.json').exists();
  }

  static Future<File> get localDataFile async {
    final path = await localPath;
    return File('$path/data.json');
  }

  static Future<File> writeDataFile(String data) async {
    final file = await localDataFile;

    // Write the file
    return file.writeAsString('$data', mode: FileMode.write);
  }

  static Future<String> readDataFile() async {
    try {
      final file = await localDataFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return "";
    }
  }

  static Future<bool> get ifNoneMatchFileAvailable async {
    final path = await localPath;
    return File('$path/if-none-match.file').exists();
  }

  static Future<File> get localIfNoneMatchFile async {
    final path = await localPath;
    return File('$path/if-none-match.file');
  }

  static Future<File> writeIfNoneMatchFile(String data) async {
    final file = await localIfNoneMatchFile;

    // Write the file
    return file.writeAsString('$data', mode: FileMode.write);
  }

  static Future<String> readIfNoneMatchFile() async {
    try {
      final file = await localIfNoneMatchFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return "";
    }
  }

  static Future<bool> get favoriteFileAvailable async {
    final path = await localPath;
    return File('$path/favorites.json').exists();
  }

  static Future<File> get localFavoriteFile async {
    final path = await localPath;
    return File('$path/favorites.json');
  }

  static Future<File> writeFavoritesFile(String data) async {
    final file = await localFavoriteFile;

    // Write the file
    return file.writeAsString('$data', mode: FileMode.write);
  }

  static Future<String> readFavoritesFile() async {
    try {
      final file = await localFavoriteFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return "";
    }
  }

  /// Options File
  static Future<bool> get settingsFileAvailable async {
    final path = await localPath;
    return File('$path/settings.json').exists();
  }

  static Future<File> get localSettingsFile async {
    final path = await localPath;
    return File('$path/settings.json');
  }

  static Future<File> writeSettingsFile(String data) async {
    final file = await localSettingsFile;

    // Write the file
    return file.writeAsString('$data', mode: FileMode.write);
  }

  static Future<String> readSettingsFile() async {
    try {
      final file = await localSettingsFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return "";
    }
  }
}
