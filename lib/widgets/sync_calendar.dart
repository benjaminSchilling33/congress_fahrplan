/*
congress_fahrplan
This is the dart file containing the SyncCalendar StatelessWidget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:collection';

import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/widgets/talk.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SyncCalendar extends StatelessWidget {
  final DeviceCalendarPlugin calendarPlugin;
  final FavoriteProvider provider;
  SyncCalendar({this.calendarPlugin, this.provider});

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: calendarPlugin.retrieveCalendars(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Result<UnmodifiableListView<Calendar>> calendarResults =
              snapshot.data;
          UnmodifiableListView<Calendar> calendars = calendarResults.data;
          return Container(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: calendars.length,
              itemBuilder: (context, index) {
                return RaisedButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.sync),
                      Container(
                        width: 200,
                        child: Text(
                          calendars[index].name,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () =>
                      syncCalendar(context, provider, calendars[index]),
                );
              },
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  syncCalendar(
      BuildContext context, FavoriteProvider provider, Calendar calendar) {
    List<Event> events = List<Event>();

    for (Talk fav in provider.fahrplan.favoriteTalks) {
      int durationH = int.parse(fav.duration.split(":")[0]);
      int durationM = int.parse(fav.duration.split(":")[1]);
      DateTime end =
          fav.date.add(Duration(hours: durationH, minutes: durationM));
      Event e = Event(calendar.id);
      e.title = fav.title;
      e.start = fav.date;
      e.description = fav.abstract;
      e.location = fav.room;
      e.end = end;
      events.add(e);
    }
    for (Event e in events) {
      calendarPlugin.createOrUpdateEvent(e);
    }
    Navigator.pop(context);
  }
}
