import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  static Future<bool> get dataFileAvailable async {
    final path = await localPath;
    return File('$path/data.json').exists();
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
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
}
