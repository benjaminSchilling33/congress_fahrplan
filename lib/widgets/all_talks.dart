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
import 'package:congress_fahrplan/widgets/favorites.dart';

class AllTalks extends StatelessWidget {
  final Future<Fahrplan> fahrplan;

  AllTalks({Key key, this.fahrplan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var favorites = Provider.of<FavoriteProvider>(context);
    return FutureBuilder<Fahrplan>(
      future: fahrplan,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          favorites.initializeProvider(snapshot.data);
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
            ),
            title: snapshot.data.getFahrplanTitle(),
            home: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  ///Portrait Orientation
                  return new DefaultTabController(
                    length: snapshot.data.conference.daysCount,
                    child: new Scaffold(
                      appBar: new AppBar(
                        title: Text(snapshot.data.getFahrplanTitle()),
                        leading: Ink(
                          child: IconButton(
                            tooltip: "Show the favorited talks.",
                            icon: Icon(
                              Icons.favorite,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Favorites(
                                  fahrplan: fahrplan,
                                ),
                              ),
                            ),
                          ),
                        ),
                        bottom: PreferredSize(
                          child: TabBar(
                            tabs: snapshot.data.conference.getDaysAsText(),
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                  color: Theme.of(context).indicatorColor),
                            ),
                          ),
                          preferredSize: Size.fromHeight(50),
                        ),
                      ),
                      body: snapshot.data.getDayTabBarView(context),
                    ),
                  );
                } else {
                  ///Landscape Orientation
                  return new DefaultTabController(
                    length: snapshot.data.conference.daysCount,
                    child: new Scaffold(
                      appBar: new AppBar(
                        title: Text(snapshot.data.getFahrplanTitle()),
                        leading: Ink(
                          child: IconButton(
                            tooltip: "Show the favorited talks.",
                            icon: Icon(
                              Icons.favorite,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Favorites(
                                  fahrplan: fahrplan,
                                ),
                              ),
                            ),
                          ),
                        ),
                        bottom: PreferredSize(
                          child: TabBar(
                            tabs: snapshot.data.conference.getDaysAsText(),
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                  color: Theme.of(context).indicatorColor),
                            ),
                          ),
                          preferredSize: Size.fromHeight(50),
                        ),
                      ),
                      body: snapshot.data.getDayTabBarView(context),
                    ),
                  );
                }
              },
            ),
          );
        }
        return new MaterialApp(
          theme: new ThemeData.dark(),
          title: 'Congress Fahrplan',
          home: new Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).indicatorColor),
                  ),
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
