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

/// The Talk widget stores all data about it and build a card with all data relevant for it.
class Talk extends StatelessWidget {
  final int id;
  final String title;
  final String track;
  final String subtitle;
  final String abstract;
  final String start;
  final String room;
  final String language;
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
      this.language,
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
      language: json['language'] != null ? json['language'] : "",
      day: start.compareTo("09:00") < 0 ? day + 1 : day,
      favorite: false,
    );
  }

  @override
  build(BuildContext context) {
    return Card(
      color: DesignConstants.primaryColor,
      child: ListTile(
        title: Text(title),
        subtitle: Text("$start - $room - $track - $language"),
        leading: Ink(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: Consumer<FavoriteProvider>(
            builder: (context, favorites, child) => IconButton(
                splashColor: DesignConstants.lightPrimaryColor,
                tooltip: "Add to favorites.",
                icon: Icon(
                  favorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () => favorites.favoriteTalk(this)),
          ),
        ),
        trailing: Ink(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: IconButton(
            splashColor: DesignConstants.lightPrimaryColor,
            tooltip: "Show details.",
            icon: Icon(
              Icons.info,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  title: Text('$title'),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            '$subtitle',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.access_time),
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            ),
                            Text(
                              '$start',
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.room),
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            ),
                            Text(
                              '$room',
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.school),
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            ),
                            Text(
                              '$track',
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.translate),
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            ),
                            Text(
                              '$language',
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Abstact: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('$abstract'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                  contentPadding: EdgeInsets.all(10),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
