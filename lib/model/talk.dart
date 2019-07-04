/*
congress_fahrplan
This is the dart file contains the Talk StatelessWidget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/utilities/design_constants.dart';

class Talk extends StatelessWidget {
  final int id;
  final String title;
  final String track;
  final String subtitle;
  final String abstract;
  final String start;
  final String room;
  final int day;
  bool favorite;

  Talk(
      {this.id,
      this.title,
      this.track,
      this.subtitle,
      this.abstract,
      this.start,
      this.room,
      this.day,
      this.favorite});

  static List<Talk> talks = new List<Talk>();

  factory Talk.fromJson(var json, String room, int day) {
    String start = json['start'] != null ? json['start'] : "";
    return Talk(
      id: json['id'] != null ? json['id'] : 0,
      title: json['title'] != null ? json['title'] : "",
      track: json['track'] != null ? json['track'] : "",
      subtitle: json['subtitle'] != null ? json['subtitle'] : "",
      abstract: json['abstract'] != null ? json['abstract'] : "",
      start: json['start'] != null ? json['start'] : "",
      room: room,
      day: start.compareTo("09:00") < 0 ? day + 1 : day,
      favorite: false,
    );
  }

  @override
  build(BuildContext context) {
    //var favorites = Provider.of<FavoriteProvider>(context);
    return Card(
      color: DesignConstants.primaryColor,
      child: ListTile(
        title: Text(title),
        subtitle: Text("$start - $room - $track"),
        leading: Ink(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: Consumer<FavoriteProvider>(
            builder: (context, favorites, child) => IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: favorite
                      ? DesignConstants.textIcons
                      : DesignConstants.primaryText,
                ),
                onPressed: () => favorites.favoriteTalk(this)),
          ),
        ),
      ),
    );
  }
}
