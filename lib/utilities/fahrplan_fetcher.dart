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

class FahrplanFetcher {
  static Future<Fahrplan> fetchFahrplan() async {
    File fahrplanFile;
    DateTime fahrplanFileLastModified;
    String fahrplanJson;

    ///Fetch the favorites from the local file
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

    ///Load the modification date of the fahrplanFile for the If-Modified-Since http request header
    if (await FileStorage.dataFileAvailable) {
      fahrplanFile = await FileStorage.localDataFile;
      fahrplanFileLastModified = await fahrplanFile.lastModified();
    }

    /// Fetch the Fahrplan from the REST API
    Fahrplan fp;
    // Complete Fahrplan : https://data.c3voc.de/35C3/everything.schedule.json
    // Only Main Rooms Fahrplan : https://fahrplan.events.ccc.de/congress/2018/Fahrplan/schedule.json
    final response = await http
        .get('https://data.c3voc.de/35C3/everything.schedule.json', headers: {
      "If-Modified-Since": fahrplanFile != null
          ? HttpDate.format(fahrplanFileLastModified.toUtc())
          : ""
    });

    ///If the HTTP Status code is 200 OK use the Fahrplan from the response,
    ///if the HTTP Status Code is 304 Not Modified use the local file.
    if (response.statusCode == 200 && response.bodyBytes != null) {
      fahrplanJson = utf8.decode(response.bodyBytes);
      FileStorage.writeDataFile(fahrplanJson);
      fp = new FahrplanDecoder().decodeFahrplanFromJson(
          json.decode(fahrplanJson)['schedule'], favTalks);
    } else if (response.statusCode == 304) {
      if (fahrplanFile != null) {
        fahrplanJson = await fahrplanFile.readAsString();
        if (fahrplanJson != null) {
          fp = new FahrplanDecoder().decodeFahrplanFromJson(
              json.decode(fahrplanJson)['schedule'], favTalks);
        }
      }
    } else {
      throw Exception('Failed to load Fahrplan');
    }
    return fp;
  }
}
