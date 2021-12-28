/*
congress_fahrplan
This is the dart file containing the Day class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2021 Benjamin Schilling
*/

import 'package:congress_fahrplan/model/room.dart';
import 'package:congress_fahrplan/widgets/talk.dart';

class Day {
  final int? index;
  final DateTime? date;

  final List<Room>? rooms;
  final List<Talk>? talks;

  Day({this.index, this.date, this.rooms, this.talks});

  factory Day.fromJson(var json) {
    return Day(
        index: json['index'],
        date: DateTime.parse(json['date']),
        rooms: jsonToRoomList(json['rooms'], DateTime.parse(json['date'])),
        talks: jsonToTalkList(json['rooms'], DateTime.parse(json['date'])));
  }

  static List<Room> jsonToRoomList(Map<String, dynamic> json, DateTime day) {
    List<Room> roomList = [];
    List<String> roomNames = new List<String>.from(json.keys);
    for (var rn in roomNames) {
      roomList.add(Room.fromJson(json[rn], rn, day));
    }
    return roomList;
  }

  static List<Talk> jsonToTalkList(var json, DateTime day) {
    List<Talk> talkList = [];
    List<String> roomNames = new List<String>.from(json.keys);
    for (var rn in roomNames) {
      talkList.addAll(Room.fromJson(json[rn], rn, day).talks!);
    }
    return talkList;
  }
}
