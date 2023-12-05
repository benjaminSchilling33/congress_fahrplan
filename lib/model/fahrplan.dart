/*
congress_fahrplan
This is the dart file containing the Fahrplan class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2021 Benjamin Schilling
*/

import 'package:congress_fahrplan/model/favorited_talks.dart';
import 'package:congress_fahrplan/model/settings.dart';
import 'package:congress_fahrplan/widgets/fahrplan_drawer.dart';
import 'package:congress_fahrplan/widgets/talk.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/linear_progress_page_indicator.dart';

import 'conference.dart';
import 'day.dart';
import 'room.dart';

enum FahrplanFetchState {
  successful,
  timeout,
  noDataConnection,
  noFile,
}

class Fahrplan {
  final String? version;
  final String? baseUrl;
  final Conference? conference;
  final FahrplanFetchState? fetchState;
  final String? fetchMessage;

  List<Day>? days;
  List<Room>? rooms;

  List<Talk>? favoriteTalks;
  FavoritedTalks? favTalkIds;

  Widget? dayTabCache;

  final currentPageNotifier = ValueNotifier<int>(0);
  final PageStorageBucket bucket = PageStorageBucket();

  final Settings? settings;

  Fahrplan({
    this.version,
    this.baseUrl,
    this.conference,
    this.days,
    this.rooms,
    this.favTalkIds,
    this.favoriteTalks,
    this.settings,
    this.fetchState,
    this.fetchMessage,
  });

  factory Fahrplan.fromJson(var json, FavoritedTalks favTalks,
      Settings settings, FahrplanFetchState fetchState) {
    return Fahrplan(
      version: json['version'],
      baseUrl: json['base_url'],
      conference: Conference.fromJson(json['conference']),
      days: List<Day>.empty(growable: true),
      rooms: List<Room>.empty(growable: true),
      favTalkIds: favTalks,
      favoriteTalks: List<Talk>.empty(growable: true),
      settings: settings,
      fetchState: fetchState,
    );
  }

  Widget buildDayLayout(BuildContext context) {
    dayTabCache = TabBarView(
      children: this.conference!.buildDayTabs(),
    );
    return new DefaultTabController(
      length: conference!.daysCount!,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text(getFahrplanTitle(), style: TextStyle(fontFamily: 'GabriellaHeavy'),),
          bottom: PreferredSize(
            child: TabBar(
              tabs: conference!.getDaysAsText(),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Theme.of(context).indicatorColor, width: 5.0),
              ),
            ),
            preferredSize: Size.fromHeight(50),
          ),
        ),
        drawer: FahrplanDrawer(
          title: 'Overview',
        ),
        body: dayTabCache,
      ),
    );
  }

  /// Room layout is shown when in landscape mode
  Widget buildRoomLayout(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(getFahrplanTitle() + ' - This view is still experimental'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constrains) =>
                LinearProgressPageIndicator(
              itemCount: rooms!.length,
              currentPageNotifier: currentPageNotifier,
              progressColor: Theme.of(context).indicatorColor,
              width: constrains.maxWidth,
              height: 10,
            ),
          ),
          Expanded(
            child: PageStorage(
              bucket: bucket,
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: days!.length + 1,
                controller: PageController(viewportFraction: 0.90),
                itemBuilder: (BuildContext context, int index) {
                  return _buildCarousel(context,
                      days![index >= days!.length ? index - 1 : index], index);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: FahrplanDrawer(
        title: 'Overview',
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, Day d, int index) {
    if (index >= days!.length) {
      return Column();
    } else {
      return Column(
        key: PageStorageKey(d.date.toString() + '$index'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              // store this controller in a State to save the carousel scroll position
              itemCount: d.rooms!.length,
              controller: PageController(viewportFraction: 0.85),
              itemBuilder: (BuildContext context, int itemIndex) {
                return buildRoom(
                    context, itemIndex, d, d.rooms![itemIndex].name!);
              },
              onPageChanged: (int itemIndex) {
                currentPageNotifier.value = itemIndex;
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildRoom(
      BuildContext context, int itemIndex, Day d, String roomName) {
    int month = d.date!.month;
    int day = d.date!.day;
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Column(
          children: <Widget>[
            Text('$month-$day - $roomName'),
            Expanded(
              child: ListView.builder(
                itemCount: d.rooms![itemIndex].talks!.length,
                itemBuilder: (context, index) {
                  return d.rooms![itemIndex].talks![index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildFavoriteList() {
    List<Column> dayColumns = [];
    for (Day d in days!) {
      List<Widget> widgets = [];
      widgets.addAll(favoriteTalks!
          .where((talk) => talk.date!.day == d.date!.day)
          .where((talk) => conference!.days!
              .firstWhere((date) => date.date!.day == talk.day!.day)
              .talks!
              .contains(talk)));
      dayColumns.add(
        Column(
          children: <Widget>[
            Expanded(
              child: new ListView.builder(
                itemCount: widgets.length,
                itemBuilder: (context, index) {
                  return widgets[index];
                },
              ),
            ),
          ],
        ),
      );
    }
    return dayColumns;
  }

  String getFahrplanTitle() {
    String acronym = conference!.acronym!;
    return '$acronym Fahrplan';
  }

  String getFavoritesTitle() {
    String acronym = conference!.acronym!;
    return '$acronym Favorites';
  }
}
