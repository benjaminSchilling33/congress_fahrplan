/*
congress_fahrplan
This is the dart file contains the Fahrplan and FavoritedTalks class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';

import 'conference.dart';
import 'package:congress_fahrplan/widgets/talk.dart';
import 'day.dart';
import 'room.dart';

import 'package:congress_fahrplan/utilities/file_storage.dart';

class Fahrplan {
  final String version;
  final String baseUrl;
  final Conference conference;

  List<Day> days;
  List<Room> rooms;

  List<Talk> favoriteTalks;
  FavoritedTalks favTalkIds;

  Widget dayTabCache;

  Fahrplan({
    this.version,
    this.baseUrl,
    this.conference,
    this.days,
    this.rooms,
    this.favTalkIds,
    this.favoriteTalks,
  });

  factory Fahrplan.fromJson(var json, FavoritedTalks favTalks) {
    return Fahrplan(
      version: json['version'],
      baseUrl: json['base_url'],
      conference: Conference.fromJson(json['conference']),
      days: new List<Day>(),
      rooms: new List<Room>(),
      favTalkIds: favTalks,
      favoriteTalks: new List<Talk>(),
    );
  }

  Widget getDayTabBarView(BuildContext context) {
    if (dayTabCache == null) {
      dayTabCache = TabBarView(
        children: this.conference.toDayTabs(),
      );
    }
    return dayTabCache;
  }

  Widget buildRoomLayout(BuildContext context) {
    return TabBarView(
      children: this.conference.toRoomTabs(),
    );
  }

  List<Widget> toFavoriteList() {
    List<Column> dayColumns = new List<Column>();
    for (Day d in days) {
      List<Widget> widgets = new List<Widget>();
      widgets
          .addAll(favoriteTalks.where((talk) => talk.date.day == d.date.day));
      dayColumns.add(
        Column(
          children: <Widget>[
            Expanded(
              child: new ListView(
                children: <Widget>[
                  Column(
                    children: widgets,
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
    return dayColumns;
  }

  String getFahrplanTitle() {
    String acronym = conference.acronym;
    return 'Congress Fahrplan - $acronym';
  }

  String getFavoritesTitle() {
    String acronym = conference.acronym;
    return 'Favorites - $acronym';
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
