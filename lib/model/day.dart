import 'package:congress_fahrplan/model/room.dart';
import 'package:congress_fahrplan/model/talk.dart';

class Day {
  final int index;
  final String date;
  final String day_start;
  final String day_end;

  final List<Room> rooms;
  final List<Talk> talks;

  Day(
      {this.index,
      this.date,
      this.day_start,
      this.day_end,
      this.rooms,
      this.talks});

  factory Day.fromJson(var json) {
    return Day(
        index: json['index'],
        date: json['date'],
        day_start: json['day_start'],
        day_end: json['day_end'],
        rooms: jsonToRoomList(json['rooms'], json['index']),
        talks: jsonToTalkList(json['rooms'], json['index']));
  }

  static List<Room> jsonToRoomList(Map<String, dynamic> json, int day) {
    List<Room> roomList = new List<Room>();
    List<String> roomNames = new List<String>.from(json.keys);
    for (var rn in roomNames) {
      roomList.add(Room.fromJson(json[rn], rn, day));
    }
    return roomList;
  }

  static List<Talk> jsonToTalkList(var json, int day) {
    List<Talk> talkList = new List<Talk>();
    List<String> roomNames = new List<String>.from(json.keys);
    for (var rn in roomNames) {
      talkList.addAll(Room.fromJson(json[rn], rn, day).talks);
    }
    return talkList;
  }
}
