/*
congress_fahrplan
This is the dart file contains the Conference class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:congress_fahrplan/model/day.dart';
import 'package:congress_fahrplan/model/talk.dart';
import 'package:congress_fahrplan/model/room.dart';
import 'package:flutter/material.dart';

class Conference {
  final String acronym;
  final String title;
  final String start;
  final String end;
  final int daysCount;
  final String timeslot_duration;
  final List<Day> days;
  final List<String> namesOfRooms;

  Conference({
    this.acronym,
    this.title,
    this.start,
    this.end,
    this.daysCount,
    this.timeslot_duration,
    this.days,
    this.namesOfRooms,
  }); //, this.rooms});

  factory Conference.fromJson(var json) {
    return Conference(
      acronym: json['acronym'],
      title: json['title'],
      start: json['start'],
      end: json['end'],
      daysCount: json['daysCount'],
      timeslot_duration: json['timeslot_duration'],
      days: jsonToDayList(json['days']),
      namesOfRooms: dayListToRoomNameList(
        jsonToDayList(json['days']),
      ),
    );
  }

  static List<Day> jsonToDayList(var json) {
    List<Day> dayList = new List<Day>();
    for (var j in json) {
      dayList.add(Day.fromJson(j));
    }
    List<Talk> reorderList = new List<Talk>();
    for (Day d in dayList) {
      for (Talk t in d.talks) {
        if (t.day > d.index) {
          reorderList.add(t);
        }
      }
    }
    for (Talk t in reorderList) {
      dayList[t.day - 2].talks.remove(t);
      dayList[t.day - 1].talks.add(t);
    }
    return dayList;
  }

  static List<String> dayListToRoomNameList(List<Day> dayList) {
    List<String> roomNameList = new List<String>();
    for (Day d in dayList) {
      for (Room r in d.rooms) {
        if (!roomNameList.contains(r.name)) {
          roomNameList.add(r.name);
        }
      }
    }
    return roomNameList;
  }

  List<Widget> toDayTabs() {
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
                      widgets.add(t.build(context));
                    }
                    int numbersOfTalks = d.talks.length;
                    int numberOfWidgets = widgets.length;
                    print(
                        "Number of talks: $numbersOfTalks - $numberOfWidgets");
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

  List<Widget> toRoomTabs() {
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
                      widgets.add(t.build(context));
                    }
                    int numbersOfTalks = d.talks.length;
                    int numberOfWidgets = widgets.length;
                    print(
                        "Number of talks: $numbersOfTalks - $numberOfWidgets");
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

  List<Widget> toFavoriteTabs() {
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
                    int numbersOfTalks = d.talks.length;
                    int numberOfWidgets = widgets.length;
                    print(
                        "Number of talks: $numbersOfTalks - $numberOfWidgets");
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

  List<Widget> getDaysAsText() {
    List<Text> dayTexts = new List<Text>();
    for (Day d in days) {
      dayTexts.add(new Text(d.date));
    }
    return dayTexts;
  }
}
