/*
congress_fahrplan
This is the dart file contains the Fahrplan and FavoritedTalks class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';

import 'conference.dart';
import 'talk.dart';
import 'day.dart';
import 'room.dart';

import 'package:congress_fahrplan/utilities/file_storage.dart';

class Fahrplan {
  final String version;
  final String base_url;
  final Conference conference;

  List<Talk> talks;
  List<Day> days;
  List<Room> rooms;

  FavoritedTalks favTalks;

  Fahrplan({
    this.version,
    this.base_url,
    this.conference,
    this.talks,
    this.days,
    this.rooms,
    this.favTalks,
  });

  factory Fahrplan.fromJson(var json, FavoritedTalks favTalks) {
    return Fahrplan(
      version: json['version'],
      base_url: json['base_url'],
      conference: Conference.fromJson(json['conference']),
      talks: new List<Talk>(),
      days: new List<Day>(),
      rooms: new List<Room>(),
      favTalks: favTalks,
    );
  }

  Widget buildDayTabs(BuildContext context) {
    return TabBarView(
      children: this.conference.toDayTabs(),
    );
  }

  Widget buildRoomLayout(BuildContext context) {
    return TabBarView(
      children: this.conference.toRoomTabs(),
    );
  }

  List<Widget> toFavoriteList() {
    List<Column> dayColumns = new List<Column>();
    for (Day d in days) {
      dayColumns.add(
        Column(
          children: <Widget>[
            Expanded(
              child: new ListView.builder(
                  itemCount: 1,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    List<Widget> widgets = new List<Widget>();
                    d.talks.sort((a, b) => a.start.compareTo(b.start));
                    for (Talk t in d.talks) {
                      if (t.favorite) {
                        widgets.add(t.build(context));
                      }
                    }
                    return new Column(
                      children: widgets,
                    );
                  }),
            ),
          ],
        ),
      );
    }
    return dayColumns;
  }
}

class FavoritedTalks {
  final List<int> ids;

  FavoritedTalks({this.ids});

  factory FavoritedTalks.fromJson(Map json) {
    if (json != null) {
      return FavoritedTalks(
        ids: json['ids'].cast<int>(),
      );
    }
    return FavoritedTalks(ids: new List<int>());
  }

  void addFavoriteTalk(int id) {
    ids.add(id);
    FileStorage.writeFavoritesFile('{"ids": $ids}');
  }

  void removeFavoriteTalk(int id) {
    ids.remove(id);
    FileStorage.writeFavoritesFile('{"ids": $ids}');
  }
}
