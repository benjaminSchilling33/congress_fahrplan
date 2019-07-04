/*
congress_fahrplan
This is the dart file contains the FavoriteProvider class which implemented the provider pattern.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:congress_fahrplan/model/talk.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/model/day.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Widget> _favorites = [];
  Fahrplan fahrplan;
  bool isInitialized = false;

  UnmodifiableListView<Widget> get favorites =>
      UnmodifiableListView(_favorites);

  void initializeProvider(Fahrplan fahrplan) async {
    if (!isInitialized) {
      this.fahrplan = fahrplan;
      isInitialized = true;
    }
  }

  void favoriteTalk(Talk talk) {
    print('favorite talk called');
    for (Talk t in fahrplan.talks) {
      if (t == talk && !t.favorite) {
        print("favorite item");
        talk.favorite = true;
        fahrplan.favTalks.addFavoriteTalk(talk.id);
      } else if (t == talk && t.favorite) {
        print("de-favorite item");
        talk.favorite = false;
        fahrplan.favTalks.removeFavoriteTalk(talk.id);
      }
    }
    notifyListeners();
  }
}
