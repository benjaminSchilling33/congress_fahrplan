/*
congress_fahrplan
This is the dart file contains the Conference class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:congress_fahrplan/model/day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Conference {
  final String acronym;
  final String title;
  final String start;
  final String end;
  int daysCount;
  final String timeslotDuration;
  final List<Day> days;
  final List<String> namesOfRooms;

  Conference({
    this.acronym,
    this.title,
    this.start,
    this.end,
    this.timeslotDuration,
    this.days,
    this.namesOfRooms,
  });

  factory Conference.fromJson(var json) {
    Conference c = Conference(
      acronym: json['acronym'],
      title: json['title'],
      start: json['start'],
      end: json['end'],
      timeslotDuration: json['timeslot_duration'],
      days: jsonToDayList(json['days']),
    );
    c.daysCount = 0;
    for (Day d in c.days) {
      if (d.talks.length > 0) {
        c.daysCount++;
      }
    }
    return c;
  }

  static List<Day> jsonToDayList(var json) {
    List<Day> days = new List<Day>();
    for (var j in json) {
      Day d = Day.fromJson(j);
      if (d.talks.length > 0) {
        days.add(d);
      }
    }
    return days;
  }

  List<Widget> buildDayTabs() {
    List<Column> dayColumns = List<Column>();
    for (Day d in days) {
      if (d.talks.length > 0) {
        List<Widget> widgets = List<Widget>();
        widgets.addAll(d.talks);
        dayColumns.add(
          Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: d.talks.length,
                  itemBuilder: (context, index) {
                    return d.talks[index];
                  },
                ),
              ),
            ],
          ),
        );
      }
    }
    return dayColumns;
  }

  List<Widget> getDaysAsText() {
    List<Widget> dayTexts = new List<Widget>();
    for (Day d in days) {
      if (d.talks.length == 0) {
        continue;
      }
      String weekday = new DateFormat.E().format(d.date);

      String dateString = d.date.month.toString() + '-' + d.date.day.toString();
      String semanticsDay = new DateFormat.EEEE().format(d.date) +
          ' ' +
          new DateFormat.yMMMMd().format(d.date);
      dayTexts.add(
        new Semantics(
          label: semanticsDay,
          child: ExcludeSemantics(
            child: Text(
              '$weekday | $dateString',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }
    return dayTexts;
  }
}
