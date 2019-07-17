/*
congress_fahrplan
This is the dart file contains the Favorites screen StatelessWidget
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/widgets/all_talks.dart';

class Favorites extends StatelessWidget {
  final Future<Fahrplan> fahrplan;

  Favorites({Key key, this.fahrplan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return FutureBuilder<Fahrplan>(
      future: fahrplan,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new MaterialApp(
            theme: Theme.of(context),
            title: snapshot.data.getFahrplanTitle(),
            home: new DefaultTabController(
              length: snapshot.data.days.length,
              child: new Scaffold(
                appBar: new AppBar(
                  title: new Text(snapshot.data.getFavoritesTitle()),
                  leading: Ink(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllTalks(
                            fahrplan: fahrplan,
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    tabs: snapshot.data.conference.getDaysAsText(),
                    indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: Theme.of(context).indicatorColor),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: snapshot.data.toFavoriteList(),
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
