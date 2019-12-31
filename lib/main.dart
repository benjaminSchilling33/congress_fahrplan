/*
congress_fahrplan
This is the dart file containing the main method, the ThemeWrapper and the CongressFahrplanApp class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:congress_fahrplan/widgets/all_talks.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';

void main() {
  runApp(ThemeWrapper());
}

class ThemeWrapper extends StatelessWidget {
  ThemeWrapper({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Color(0xff000000),
        tabBarTheme: TabBarTheme(
          indicator: UnderlineTabIndicator(),
        ),
        primaryColorDark: Color(0xff000000),
        indicatorColor: Color(0xFFFE5000),
        accentColor: Color(0xFFFE5000),
        textTheme: TextTheme(
          title: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          body1: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          body2: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          subtitle: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          subhead: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          display1: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          caption: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          overline: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          headline: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
        ),
        cardColor: Color(0xFF3b3b3b),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF4d4d4d),
          actionTextColor: Color(0xFFFE50000),
          contentTextStyle: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          elevation: 30,
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFF1a1a1a),
          iconTheme: IconThemeData(
            color: Color(0xFFFE5000),
          ),
        ),
        buttonColor: Color(0xFFFE5000),
        iconTheme: IconThemeData(
          color: Color(0xFFFE5000),
        ),
        toggleableActiveColor: Color(0xFFFE5000),
      ),
      home: CongressFahrplanApp(key: key),
    );
  }
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
              if (favoriteProvider.fahrplan.fetchState ==
                  FahrplanFetchState.successful) {
                return AllTalks(
                  theme: Theme.of(context),
                );
              } else {
                return new MaterialApp(
                  theme: Theme.of(context),
                  title: 'Congress Fahrplan',
                  home: new Scaffold(
                    backgroundColor: Color(0xff000000),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/destruction.svg'),
                          Text(
                            'Could not fetch Fahrplan!',
                          ),
                          Text(
                            favoriteProvider.fahrplan.fetchMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
              return new MaterialApp(
                theme: Theme.of(context),
                title: 'Congress Fahrplan',
                home: new Scaffold(
                  backgroundColor: Color(0xff000000),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SvgPicture.asset('assets/destruction.svg'),
                        CircularProgressIndicator(),
                        Container(
                          child: Text('Fetching Fahrplan'),
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
