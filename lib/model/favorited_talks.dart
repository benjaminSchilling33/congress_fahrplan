/*
congress_fahrplan
This is the dart file containing the FavoritedTalks class needed by the Fahrplan class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2021 Benjamin Schilling
*/

import 'package:congress_fahrplan/utilities/file_storage.dart';

class FavoritedTalks {
  final List<int> ids;

  FavoritedTalks({required this.ids});

  factory FavoritedTalks.fromJson(Map json) {
    return FavoritedTalks(
      ids: json['ids'].cast<int>(),
    );
  }

  void addFavoriteTalk(int id) {
    ids.add(id);
    FileStorage.writeFavoritesFile('{"ids": $ids}');
  }

  void removeFavoriteTalk(int id) {
    ids.remove(id);
    FileStorage.writeFavoritesFile('{"ids": $ids}');
  }

  bool contains(int id) {
    if (ids.contains(id)) {
      return true;
    }
    return false;
  }
}
