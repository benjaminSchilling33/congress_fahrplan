import 'package:congress_fahrplan/model/talk.dart';

class Room {
  final String name;
  final List<Talk> talks;

  static int numberOfRooms = 0;
  static List<String> namesOfRooms = new List<String>();

  Room({this.name, this.talks});

  factory Room.fromJson(var json, String name, int day) {
    return Room(name: name, talks: jsonToTalkList(json, name, day));
  }

  static List<Talk> jsonToTalkList(var json, String name, int day) {
    List<Talk> talkList = new List<Talk>();
    for (var j in json) {
      talkList.add(Talk.fromJson(j, name, day));
      Talk.talks.add(Talk.fromJson(j, name, day));
    }
    return talkList;
  }
}
