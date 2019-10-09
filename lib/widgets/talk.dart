/*
congress_fahrplan
This is the dart file contains the Talk StatelessWidget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';

/// The Talk widget stores all data about it and build a card with all data relevant for it.
class Talk extends StatelessWidget {
  DateTime day;
  final int id;
  final String title;
  final String track;
  final String subtitle;
  final String abstract;
  final String start;
  final String room;
  final String language;
  final DateTime date;
  final String url;
  final List<Person> persons;
  bool favorite;

  Talk(
      {this.id,
      this.title,
      this.track,
      this.subtitle,
      this.abstract,
      this.start,
      this.room,
      this.date,
      this.language,
      this.url,
      this.persons,
      this.favorite});

  factory Talk.fromJson(var json, String room) {
    return Talk(
      id: json['id'] != null ? json['id'] : 0,
      title: json['title'] != null ? json['title'] : "",
      track: json['track'] != null ? json['track'] : "",
      subtitle: json['subtitle'] != null ? json['subtitle'] : "",
      abstract: json['abstract'] != null ? json['abstract'] : "",
      start: json['start'] != null ? json['start'] : "",
      room: room,
      language: json['language'] != null ? json['language'] : "",
      date: DateTime.parse(json['date']),
      url: json['url'] != null ? json['url'] : "",
      persons: jsonToPersonList(json['persons']),
      favorite: false,
    );
  }

  static List<Person> jsonToPersonList(var json) {
    List<Person> persons = new List<Person>();
    for (var j in json) {
      persons.add(Person.fromJson(j));
    }
    return persons;
  }

  void setDay(DateTime d) {
    this.day = d;
  }

  @override
  build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: getCardSubtitle(),
        leading: Ink(
          child: Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) => IconButton(
                tooltip: "Add to favorites.",
                icon: Icon(
                  favorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () =>
                    favoriteProvider.favoriteTalk(context, this, day)),
          ),
        ),
        trailing: Ink(
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: IconButton(
            tooltip: "Show details.",
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  title: Text('$title'),
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getDetails())
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

  Text getCardSubtitle() {
    String textString = '';
    textString = textString +
        ('$start' != '' ? ('$room' != '' ? '$start' + ' - ' : '$start') : '');
    textString = textString +
        ('$room' != '' ? ('$track' != '' ? '$room' + ' - ' : '$room') : '');
    textString = textString +
        ('$track' != ''
            ? ('$language' != '' ? '$track' + ' - ' : '$track')
            : '');
    textString = textString + ('$language' != '' ? '$language' : '');
    return Text(textString);
  }

  List<Widget> getDetails() {
    List<Widget> widgets = new List<Widget>();

    /// Add the subtitle
    if (subtitle != null && subtitle != '') {
      widgets.add(
        Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Text(
            '$subtitle',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
      );
    }

    /// Add the time details
    if (start != null && start != '') {
      widgets.add(Row(
        children: <Widget>[
          Container(
            child: Icon(Icons.access_time),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          Text(
            '$start',
          ),
        ],
      ));
    }

    /// Add the room details
    if (room != null && room != '') {
      widgets.add(Row(
        children: <Widget>[
          Container(
            child: Icon(Icons.room),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          Text(
            '$room',
          ),
        ],
      ));
    }

    /// Add the track details
    if (track != null && track != '') {
      widgets.add(Row(
        children: <Widget>[
          Container(
            child: Icon(Icons.school),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          Text(
            '$track',
          ),
        ],
      ));
    }

    /// Add the language details
    if (language != null && language != '') {
      widgets.add(Row(
        children: <Widget>[
          Container(
            child: Icon(Icons.translate),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          Text(
            '$language',
          ),
        ],
      ));
    }

    /// Add the url details
    if (url != null && url != '') {
      widgets.add(Row(
        children: <Widget>[
          Container(
            child: Icon(Icons.open_in_browser),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          Expanded(
            child: Linkify(
              onOpen: (link) async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $link';
                }
              },
              text: "$url",
              style: TextStyle(),
            ),
          )
        ],
      ));
    }

    /// Add the persons details
    if (persons != null && persons.length > 0) {
      String personsString = '';
      for (Person p in persons) {
        personsString += p.publicName +
            (persons.last.publicName == p.publicName ? '' : ' - ');
      }
      widgets.add(Row(
        children: <Widget>[
          Container(
            child: Icon(Icons.group),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
          Text(personsString),
        ],
      ));
    }

    /// Add the abstract text
    if (abstract != null && abstract != '') {
      widgets.add(
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Abstract: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('$abstract'),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}

class Person {
  int id;
  String publicName;

  Person({this.id, this.publicName});

  factory Person.fromJson(var json) {
    return Person(
      id: json['id'] != null ? json['id'] : 0,
      publicName: json['public_name'] != null ? json['public_name'] : "",
    );
  }
}
