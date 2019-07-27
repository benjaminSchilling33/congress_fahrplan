/*
congress_fahrplan
This is the dart file contains the AllTalks screen StatelessWidget
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:provider/provider.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';

class AllTalksWidget extends StatefulWidget {
  Future<Fahrplan> fahrplan;
  AllTalksWidget({this.fahrplan});

  @override
  State<StatefulWidget> createState() {
    return AllTalks(fahrplan: fahrplan);
  }
}

class AllTalks extends State<AllTalksWidget> {
  Future<Fahrplan> fahrplan;

  AllTalks({Key key, this.fahrplan});

  @override
  Widget build(BuildContext context) {
    var favorites = Provider.of<FavoriteProvider>(context);
    return FutureBuilder<Fahrplan>(
      future: fahrplan,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          favorites.initializeProvider(snapshot.data);
          return new MaterialApp(
            theme: Theme.of(context),
            title: snapshot.data.getFahrplanTitle(),
            home: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  ///Portrait Orientation
                  return snapshot.data.buildDayLayout(context, fahrplan);
                } else {
                  ///Landscape Orientation
                  return snapshot.data.buildRoomLayout(context, fahrplan);
                }
              },
            ),
          );
        }
        return new MaterialApp(
          theme: Theme.of(context),
          title: 'Congress Fahrplan',
          home: new Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Container(
                    child: Text('Loading Fahrplan'),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
