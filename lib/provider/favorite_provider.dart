/*
congress_fahrplan
This is the dart file contains the FavoriteProvider class which implemented the provider pattern.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:congress_fahrplan/widgets/talk.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';

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

  void favoriteTalk(Talk talk, DateTime talkDate) {
    for (Talk t
        in fahrplan.days.firstWhere((day) => day.date == talkDate).talks) {
      if (t == talk && !t.favorite) {
        talk.favorite = true;
        fahrplan.favTalkIds.addFavoriteTalk(talk.id);
        fahrplan.favoriteTalks.add(talk);
        fahrplan.favoriteTalks.sort((a, b) => a.date.compareTo(b.date));
      } else if (t == talk && t.favorite) {
        talk.favorite = false;
        fahrplan.favTalkIds.removeFavoriteTalk(talk.id);
        fahrplan.favoriteTalks.remove(talk);
        fahrplan.favoriteTalks.sort((a, b) => a.date.compareTo(b.date));
      }
    }
    notifyListeners();
  }
}
