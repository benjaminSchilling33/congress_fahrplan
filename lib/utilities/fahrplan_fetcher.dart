/*
congress_fahrplan
This is the dart file containing the FahrplanFetcher class needed to fetch the Fahrplan.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import 'package:congress_fahrplan/utilities/file_storage.dart';
import 'package:congress_fahrplan/utilities/fahrplan_decoder.dart';

import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/model/favorited_talks.dart';
import 'package:congress_fahrplan/model/settings.dart';

class FahrplanFetcher {
  static Future<Fahrplan> fetchFahrplan() async {
    File fahrplanFile;
    DateTime fahrplanFileLastModified;
    String fahrplanJson;

    /// Used to reduce traffic
    String ifNoneMatch;
    String ifModifiedSince;

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
      favTalks = new FavoritedTalks(
        ids: new List<int>(),
      );
    }

    ///Load the modification date of the fahrplanFile for the If-Modified-Since http request header
    if (await FileStorage.dataFileAvailable) {
      fahrplanFile = await FileStorage.localDataFile;
      fahrplanFileLastModified = await fahrplanFile.lastModified();
    }

    ///Load the If-None-Match
    if (await FileStorage.ifNoneMatchFileAvailable) {
      ifNoneMatch = await FileStorage.readIfNoneMatchFile();
      print('if none match file available, content: $ifNoneMatch');
    } else {
      ifNoneMatch = "";
      print('if none match file not available, content: $ifNoneMatch');
    }

    /// Set If-Modified-Since
    ifModifiedSince = fahrplanFile != null
        ? HttpDate.format(fahrplanFileLastModified.toUtc())
        : "";

    /// Load the Settings
    Settings settings = await Settings.restoreSettingsFromFile();

    /// Fetch the Fahrplan from the REST API
    /// Check for network connectivity
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      /// Fetch the fahrplan depending on what is set in the settings, if the timeout of 4 seconds expires load the
      String requestString =
          'https://fahrplan.events.ccc.de/congress/2019/Fahrplan/schedule.json';

      if (settings.getLoadFullFahrplan()) {
        /// Complete Fahrplan
        requestString = 'https://data.c3voc.de/36C3/everything.schedule.json';
      } else {
        /// Only Main Rooms Fahrplan
        requestString =
            'https://fahrplan.events.ccc.de/congress/2019/Fahrplan/schedule.json';
      }
      final response = await http
          .get(
            '$requestString',
            headers: {
              "If-Modified-Since": ifModifiedSince,
              "If-None-Match": ifNoneMatch,
            },
          )
          .timeout(const Duration(seconds: 10))
          .catchError((e) {
            print('timeout');
          });

      ///If the HTTP Status code is 200 OK use the Fahrplan from the response,
      ///Else if the HTTP Status Code is 304 Not Modified use the local file.
      ///Else if a local fahrplan file is available use it
      ///Else return empty fahrplan
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200 && response.bodyBytes != null) {
          fahrplanJson = utf8.decode(response.bodyBytes);

          /// Store the etag
          String etag = response.headers['etag'];
          FileStorage.writeIfNoneMatchFile('$etag');

          /// Store the fetched JSON
          FileStorage.writeDataFile(fahrplanJson);

          return new FahrplanDecoder().decodeFahrplanFromJson(
            json.decode(fahrplanJson)['schedule'],
            favTalks,
            settings,
            FahrplanFetchState.successful,
          );
        } else if (response.statusCode == 304 && fahrplanFile != null) {
          fahrplanJson = await fahrplanFile.readAsString();
          if (fahrplanJson != null && fahrplanJson != '') {
            return new FahrplanDecoder().decodeFahrplanFromJson(
              json.decode(fahrplanJson)['schedule'],
              favTalks,
              settings,
              FahrplanFetchState.successful,
            );
          }
        } else {
          return new Fahrplan(fetchState: FahrplanFetchState.timeout);
        }
      } else {
        if (fahrplanFile != null) {
          fahrplanJson = await fahrplanFile.readAsString();
          if (fahrplanJson != null && fahrplanJson != '') {
            return new FahrplanDecoder().decodeFahrplanFromJson(
              json.decode(fahrplanJson)['schedule'],
              favTalks,
              settings,
              FahrplanFetchState.successful,
            );
          }
        } else {
          return new Fahrplan(fetchState: FahrplanFetchState.timeout);
        }
      }

      /// If not connected, try to load from file, otherwise set Fahrplan.isEmpty
    } else {
      if (fahrplanFile != null) {
        fahrplanJson = await fahrplanFile.readAsString();
        if (fahrplanJson != null && fahrplanJson != '') {
          return new FahrplanDecoder().decodeFahrplanFromJson(
            json.decode(fahrplanJson)['schedule'],
            favTalks,
            settings,
            FahrplanFetchState.successful,
          );
        }
      } else {
        return new Fahrplan(fetchState: FahrplanFetchState.noDataConnection);
      }
    }
  }
}
