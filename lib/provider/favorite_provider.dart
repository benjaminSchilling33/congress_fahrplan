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
      if (t.id == talk.id && !t.favorite) {
        /// Set favorite of talk in correct room to true
        fahrplan.days
            .firstWhere((day) => day.date == talkDate)
            .rooms
            .firstWhere((room) => room.name == talk.room)
            .talks
            .firstWhere((ta) => (ta.id == talk.id && !ta.favorite))
            .favorite = true;

        /// Set favorite of this talk to true
        talk.favorite = true;

        /// Set favorite of talk in day to true
        t.favorite = true;
        fahrplan.favTalkIds.addFavoriteTalk(talk.id);
        fahrplan.favoriteTalks.add(talk);
        fahrplan.favoriteTalks.sort((a, b) => a.date.compareTo(b.date));
        notifyListeners();
        return;
      } else if (t.id == talk.id && t.favorite) {
        fahrplan.days
            .firstWhere((day) => day.date == talkDate)
            .rooms
            .firstWhere((room) => room.name == talk.room)
            .talks
            .firstWhere((ta) => (ta.id == talk.id && ta.favorite))
            .favorite = false;
        talk.favorite = false;
        t.favorite = false;
        fahrplan.favTalkIds.removeFavoriteTalk(talk.id);
        fahrplan.favoriteTalks.removeWhere((ta) => ta.id == talk.id);
        fahrplan.favoriteTalks.sort((a, b) => a.date.compareTo(b.date));
        notifyListeners();
        return;
      }
    }
  }
}
