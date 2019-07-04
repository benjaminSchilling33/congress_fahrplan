import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/model/talk.dart';
import 'package:congress_fahrplan/model/day.dart';

class FahrplanDecoder {
  // Decodes the Fahrplan, initializes it and sets all favorited talks
  Fahrplan decodeFahrplanFromJson(
      Map<String, dynamic> json, FavoritedTalks favTalks) {
    Fahrplan f = Fahrplan.fromJson(json, favTalks);

    //Initialize days, rooms and talks
    for (Day d in f.conference.days) {
      f.days.add(d);
      f.rooms.addAll(d.rooms);
      for (Talk t in d.talks) {
        f.talks.add(t);
      }
    }

    //set all favorites talks
    for (int i in f.favTalks.ids) {
      for (Talk t in f.talks) {
        if (t.id == i) {
          f.talks.elementAt(f.talks.indexOf(t)).favorite = true;
        }
      }
    }
    return f;
  }
}
