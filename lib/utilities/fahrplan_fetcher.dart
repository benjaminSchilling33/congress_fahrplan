/*
congress_fahrplan
This is the dart file containing the FahrplanFetcher class needed to fetch the Fahrplan.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2021 Benjamin Schilling
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/model/favorited_talks.dart';
import 'package:congress_fahrplan/model/settings.dart';
import 'package:congress_fahrplan/utilities/fahrplan_decoder.dart';
import 'package:congress_fahrplan/utilities/file_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class FahrplanFetcher {
  static String minimalFahrplanUrl =
      'https://static.rc3.world/schedule/everything.json';

  static bool multipleSchedules = false;

  static String completeFahrplanUrl = '';

  static List<String> oldUrls = [
    'https://fahrplan.events.ccc.de/rc3/2020/Fahrplan/schedule.json',
    'https://data.c3voc.de/rC3/everything.schedule.json'
  ];

  static Future<Fahrplan> fetchFahrplan() async {
    late File fahrplanFile;
    DateTime fahrplanFileLastModified = DateTime.now();
    String fahrplanJson;

    /// Used to reduce traffic
    String ifNoneMatch;
    String ifModifiedSince;

    ///Fetch the favorites from the local file
    late FavoritedTalks favTalks;
    File favoriteFile;
    if (await FileStorage.favoriteFileAvailable) {
      favoriteFile = await FileStorage.localFavoriteFile;
      String favoriteData = await favoriteFile.readAsString();
      favTalks = FavoritedTalks.fromJson(json.decode(favoriteData));
    } else {
      favTalks = new FavoritedTalks(
        ids: List<int>.empty(growable: true),
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
    } else {
      ifNoneMatch = "";
    }

    /// Set If-Modified-Since
    ifModifiedSince = HttpDate.format(fahrplanFileLastModified.toUtc());

    /// Load the Settings
    Settings settings = await Settings.restoreSettingsFromFile();

    /// Fetch the Fahrplan from the REST API
    /// Check for network connectivity
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      /// Fetch the fahrplan depending on what is set in the settings,
      /// if the timeout expires load the local fahrplan
      String requestString = FahrplanFetcher.minimalFahrplanUrl;

      if (settings.getLoadFullFahrplan() && multipleSchedules) {
        /// Complete Fahrplan
        requestString = FahrplanFetcher.completeFahrplanUrl;
      } else {
        /// Only Main Rooms Fahrplan
        requestString = FahrplanFetcher.minimalFahrplanUrl;
      }
      final Uri uri = Uri.parse('$requestString');
      final response = await http
          .get(
            uri,
            headers: {
              "If-Modified-Since": ifModifiedSince,
              "If-None-Match": ifNoneMatch,
            },
          )
          .timeout(const Duration(seconds: 20))
          .catchError((e) {});

      ///If the HTTP Status code is 200 OK use the Fahrplan from the response,
      ///Else if the HTTP Status Code is 304 Not Modified use the local file.
      ///Else if a local fahrplan file is available use it
      ///Else return empty fahrplan
      if (response.statusCode == 200 && response.bodyBytes.length > 0) {
        fahrplanJson = utf8.decode(response.bodyBytes);

        /// Store the etag
        String etag = "";
        if (response.headers.containsKey('etag')) {
          etag = response.headers['etag']!;
        }
        FileStorage.writeIfNoneMatchFile('$etag');

        /// Store the fetched JSON
        FileStorage.writeDataFile(fahrplanJson);

        return new FahrplanDecoder().decodeFahrplanFromJson(
          json.decode(fahrplanJson)['schedule'],
          favTalks,
          settings,
          FahrplanFetchState.successful,
        );
      } else if (response.statusCode == 304) {
        fahrplanJson = await fahrplanFile.readAsString();
        if (fahrplanJson != '') {
          return new FahrplanDecoder().decodeFahrplanFromJson(
            json.decode(fahrplanJson)['schedule'],
            favTalks,
            settings,
            FahrplanFetchState.successful,
          );
        }
      } else {
        return new Fahrplan(
          fetchState: FahrplanFetchState.timeout,
          fetchMessage: 'Please check your network connection.',
        );
      }

      /// If not connected, try to load from file, otherwise set Fahrplan.isEmpty
    } else {
      fahrplanJson = await fahrplanFile.readAsString();
      if (fahrplanJson != '') {
        return new FahrplanDecoder().decodeFahrplanFromJson(
          json.decode(fahrplanJson)['schedule'],
          favTalks,
          settings,
          FahrplanFetchState.successful,
        );
      } else {
        return new Fahrplan(
          fetchState: FahrplanFetchState.noDataConnection,
          fetchMessage: 'Please enable mobile data or Wifi.',
        );
      }
    }
    return new Fahrplan(
      fetchState: FahrplanFetchState.noDataConnection,
      fetchMessage: 'Could not fetch Fahrplan.',
    );
  }
}
