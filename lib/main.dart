/*
congress_fahrplan
This is the dart file contains the main method and the CongressFahrplanApp class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:congress_fahrplan/widgets/all_talks.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';

void main() {
  runApp(CongressFahrplanApp());
}

class CongressFahrplanApp extends StatelessWidget {
  CongressFahrplanApp({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => FavoriteProvider(),
      child: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) => FutureBuilder<Fahrplan>(
          future: favoriteProvider.futureFahrplan,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              favoriteProvider.initializeProvider(snapshot.data);
              return AllTalks(
                theme: ThemeData(
                  brightness: Brightness.dark,
                  backgroundColor: Color(0xff000a12),
                  tabBarTheme: TabBarTheme(
                    indicator: UnderlineTabIndicator(),
                  ),
                  primaryColorDark: Color(0xFF000A12),
                  indicatorColor: Color(0xFFffb300),
                  accentColor: Color(0xFFffb300),
                  textTheme: TextTheme(
                    title: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    body1: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    body2: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    subtitle: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    subhead: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    display1: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    caption: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    overline: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    headline: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                  ),
                  cardColor: Color(0xFF4F5B62),
                  appBarTheme: AppBarTheme(
                    color: Color(0xFF263238),
                    iconTheme: IconThemeData(
                      color: Color(0xFFffb300),
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: Color(0xFFffb300),
                  ),
                  toggleableActiveColor: Color(0xFFffb300),
                ),
              );
            } else {
              return new MaterialApp(
                theme: new ThemeData(
                  brightness: Brightness.dark,
                  backgroundColor: Color(0xff000a12),
                  tabBarTheme: TabBarTheme(
                    indicator: UnderlineTabIndicator(),
                  ),
                  primaryColorDark: Color(0xFF000A12),
                  indicatorColor: Color(0xFFffb300),
                  accentColor: Color(0xFFffb300),
                  textTheme: TextTheme(
                    title: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    body1: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    body2: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    subtitle: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    subhead: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    display1: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    caption: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    overline: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                    headline: TextStyle(
                      color: Color(0xFFFAFAFA),
                    ),
                  ),
                  cardColor: Color(0xFF4F5B62),
                  appBarTheme: AppBarTheme(
                    color: Color(0xFF263238),
                    iconTheme: IconThemeData(
                      color: Color(0xFFffb300),
                    ),
                  ),
                  iconTheme: IconThemeData(
                    color: Color(0xFFffb300),
                  ),
                  toggleableActiveColor: Color(0xFFffb300),
                ),
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
            }
          },
        ),
      ),
    );
  }
}
