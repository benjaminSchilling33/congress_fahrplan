/*
congress_fahrplan
This is the dart file contains the NetworkCommunication class needed to fetch the Fahrplan.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:congress_fahrplan/utilities/file_storage.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/utilities/fahrplan_decoder.dart';

class NetworkCommunication {
  static Future<Fahrplan> fetchFahrplan() async {
    File dataFile;
    DateTime dt;
    String data;
    if (await FileStorage.dataFileAvailable) {
      dataFile = await FileStorage.localDataFile;
      dt = await dataFile.lastModified();
    }
    // Fetch the Fahrplan from the REST API
    Fahrplan fp;
    // Complete Fahrplan : https://http://data.c3voc.de/35C3/everything.schedule.json
    // Only Main Rooms Fahrplan : https://fahrplan.events.ccc.de/congress/2018/Fahrplan/schedule.json
    final response = await http.get(
        'https://fahrplan.events.ccc.de/congress/2018/Fahrplan/schedule.json',
        headers: {
          "If-Modified-Since":
              dataFile != null ? HttpDate.format(dt.toUtc()) : ""
        });

    //Fetch the favorited from the local file
    FavoritedTalks favTalks;
    File favoriteFile;
    if (await FileStorage.favoriteFileAvailable) {
      favoriteFile = await FileStorage.localFavoriteFile;
      String favoriteData = await favoriteFile.readAsString();
      print(favoriteData);
      if (favoriteData != null) {
        favTalks = FavoritedTalks.fromJson(json.decode(favoriteData));
      }
    } else {
      favTalks = new FavoritedTalks(ids: new List<int>());
    }
    if (response.statusCode == 200 && response.bodyBytes != null) {
      data = utf8.decode(response.bodyBytes);
      FileStorage.writeDataFile(data);
      fp = new FahrplanDecoder()
          .decodeFahrplanFromJson(json.decode(data)['schedule'], favTalks);
    } else if (response.statusCode == 304) {
      if (dataFile != null) {
        data = await dataFile.readAsString();
        if (data != null) {
          fp = new FahrplanDecoder()
              .decodeFahrplanFromJson(json.decode(data)['schedule'], favTalks);
        }
      }
    } else {
      throw Exception('Failed to load Fahrplan');
    }
    return fp;
  }
}
