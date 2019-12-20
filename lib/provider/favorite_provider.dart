/*
congress_fahrplan
This is the dart file containing the FavoriteProvider class which implements the provider pattern.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:congress_fahrplan/widgets/talk.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';

import 'package:congress_fahrplan/utilities/fahrplan_fetcher.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Widget> _favorites = [];
  Future<Fahrplan> futureFahrplan;
  Fahrplan fahrplan;
  bool isInitialized = false;

  UnmodifiableListView<Widget> get favorites =>
      UnmodifiableListView(_favorites);

  FavoriteProvider() {
    futureFahrplan = FahrplanFetcher.fetchFahrplan();
  }

  void initializeProvider(Fahrplan fahrplan) async {
    this.fahrplan = fahrplan;
    isInitialized = true;
  }

  void notifyMainListeners() {
    notifyListeners();
  }

  void favoriteTalk(BuildContext context, Talk talk, DateTime talkDate) {
    for (Talk t
        in fahrplan.days.firstWhere((day) => day.date == talkDate).talks) {
      /// Check for 1. a matching talk id, 2. favorite is not set and (if favorites has elements) 3. that the talk not exists in favorite talks
      if (t.id == talk.id && !t.favorite) {
        if (fahrplan.favoriteTalks.length > 0) {
          for (Talk fav in fahrplan.favoriteTalks) {
            if (fav.id == talk.id) {
              return;
            } else {
              if (context != null) {
                String talkName = talk.title;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('\"$talkName\" added to favorites.'),
                  action: SnackBarAction(
                    label: "Revert",
                    onPressed: () => this.favoriteTalk(null, talk, talkDate),
                  ),
                  duration: Duration(seconds: 3),
                ));
              }

              favorite(t, talk, talkDate);
              return;
            }
          }
        } else {
          if (context != null) {
            String talkName = talk.title;
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('\"$talkName\" added to favorites.'),
              action: SnackBarAction(
                label: "Revert",
                onPressed: () => this.favoriteTalk(null, talk, talkDate),
              ),
              duration: Duration(seconds: 3),
            ));
          }
          favorite(t, talk, talkDate);
          return;
        }
      } else if (t.id == talk.id && t.favorite) {
        /// If the talk exists and is favorites, remove it from the list of favorites
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
        if (context != null) {
          String talkName = talk.title;
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('\"$talkName\" removed from favorites.'),
            action: SnackBarAction(
              label: "Revert",
              onPressed: () => this.favoriteTalk(null, talk, talkDate),
            ),
            duration: Duration(seconds: 3),
          ));
        }
        return;
      }
    }
  }

  void favorite(Talk t, Talk talk, DateTime talkDate) {
    /// Set favorite of talk in correct room to true
    fahrplan.days
        .firstWhere((day) => day.date == talkDate)
        .rooms
        .firstWhere((room) => room.name == talk.room, orElse: null)
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
  }
}
