/*
congress_fahrplan
This is the dart file containing the FahrplanDecoder class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/model/day.dart';
import 'package:congress_fahrplan/model/room.dart';
import 'package:congress_fahrplan/model/favorited_talks.dart';
import 'package:congress_fahrplan/model/settings.dart';

import 'package:congress_fahrplan/widgets/talk.dart';

class FahrplanDecoder {
  // Decodes the Fahrplan, initializes it and sets all favorited talks
  Fahrplan decodeFahrplanFromJson(
      Map<String, dynamic> json,
      FavoritedTalks favTalks,
      Settings settings,
      FahrplanFetchState fetchState) {
    Fahrplan f = Fahrplan.fromJson(json, favTalks, settings, fetchState);

    //Initialize days, rooms and sort talks of days

    List<Room> allRooms = new List<Room>();
    for (Day d in f.conference.days) {
      f.days.add(d);
      allRooms.addAll(d.rooms);
      d.talks.sort((a, b) => a.date.compareTo(b.date));
    }

    // Create a reduced list of rooms and assign it to the fahrplan
    List<Room> reducedRooms = new List<Room>();
    for (Room r in allRooms) {
      if (reducedRooms.length != 0) {
        if (reducedRooms.firstWhere((room) => room.name == r.name,
                orElse: () => null) !=
            null) {
          reducedRooms
              .firstWhere((room) => room.name == r.name)
              .talks
              .addAll(r.talks);
        } else {
          reducedRooms.add(r);
        }
      } else {
        reducedRooms.add(r);
      }
    }
    f.rooms = reducedRooms;

    //set all favorites talks for each day and each rooms of each day
    for (int i in f.favTalkIds.ids) {
      for (Day d in f.days) {
        for (Talk t in d.talks) {
          if (t.id == i) {
            f.favoriteTalks.add(t);
            d.talks.elementAt(d.talks.indexOf(t)).favorite = true;
            break;
          }
        }
        for (Room r in d.rooms) {
          for (Talk t in r.talks) {
            if (t.id == i) {
              f.favoriteTalks.add(t);
              r.talks.elementAt(r.talks.indexOf(t)).favorite = true;
              break;
            }
          }
        }
      }
    }
    return f;
  }
}
