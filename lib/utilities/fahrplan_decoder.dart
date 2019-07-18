/*
congress_fahrplan
This is the dart file contains the FahrplanDecoder class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/widgets/talk.dart';
import 'package:congress_fahrplan/model/day.dart';

class FahrplanDecoder {
  // Decodes the Fahrplan, initializes it and sets all favorited talks
  Fahrplan decodeFahrplanFromJson(
      Map<String, dynamic> json, FavoritedTalks favTalks) {
    Fahrplan f = Fahrplan.fromJson(json, favTalks);

    //Initialize days, rooms and sort talks of days
    for (Day d in f.conference.days) {
      f.days.add(d);
      f.rooms.addAll(d.rooms);
      d.talks.sort((a, b) => a.date.compareTo(b.date));
    }

    //set all favorites talks
    for (int i in f.favTalkIds.ids) {
      for (Day d in f.days) {
        for (Talk t in d.talks) {
          if (t.id == i) {
            f.favoriteTalks.add(t);
            d.talks.elementAt(d.talks.indexOf(t)).favorite = true;
            break;
          }
        }
      }
    }
    return f;
  }
}
