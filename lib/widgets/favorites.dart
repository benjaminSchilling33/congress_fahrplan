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
import 'package:congress_fahrplan/utilities/design_constants.dart';

class Favorites extends StatelessWidget {
  final Future<Fahrplan> fahrplan;

  Favorites({Key key, this.fahrplan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return new MaterialApp(
      theme: new ThemeData.dark(),
      title: 'Congress Fahrplan',
      routes: {
        '/alltalks': (context) => AllTalks(
              fahrplan: fahrplan,
            ),
      },
      home: FutureBuilder<Fahrplan>(
        future: fahrplan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new DefaultTabController(
              length: snapshot.data.days.length,
              child: new Scaffold(
                appBar: new AppBar(
                  backgroundColor: DesignConstants.darkPrimaryColor,
                  title: new Text('Favorites'),
                  leading: Ink(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/alltalks'),
                    ),
                  ),
                  bottom: TabBar(
                    tabs: snapshot.data.conference.getDaysAsText(),
                    indicatorColor: DesignConstants.lightPrimaryColor,
                  ),
                ),
                body: TabBarView(
                  children: snapshot.data.toFavoriteList(),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
