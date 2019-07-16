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

import 'package:congress_fahrplan/utilities/design_constants.dart';

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
                theme: new ThemeData.dark(),
                title: 'Congress Fahrplan',
                home: OrientationBuilder(builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return new DefaultTabController(
                      length: snapshot.data.conference.daysCount,
                      child: new Scaffold(
                        appBar: new AppBar(
                          backgroundColor: DesignConstants.darkPrimaryColor,
                          title: new Text('Congress Fahrplan'),
                          leading: Ink(
                            child: IconButton(
                              tooltip: "Show the favorited talks.",
                              splashColor: DesignConstants.lightPrimaryColor,
                              icon: Icon(
                                Icons.favorite,
                                color: DesignConstants.textIcons,
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
                              indicatorColor: DesignConstants.lightPrimaryColor,
                              tabs: snapshot.data.conference.getDaysAsText(),
                            ),
                            preferredSize: Size.fromHeight(50),
                          ),
                        ),
                        body: snapshot.data.buildDayTabs(context),
                      ),
                    );
                  } else {
                    return new DefaultTabController(
                      length: snapshot.data.conference.daysCount,
                      child: new Scaffold(
                        appBar: new AppBar(
                          backgroundColor: DesignConstants.darkPrimaryColor,
                          title: new Text('Congress Fahrplan'),
                          leading: Ink(
                            child: IconButton(
                              tooltip: "Show the favorited talks.",
                              splashColor: DesignConstants.lightPrimaryColor,
                              icon: Icon(
                                Icons.favorite,
                                color: DesignConstants.textIcons,
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
                              indicatorColor: DesignConstants.lightPrimaryColor,
                              tabs: snapshot.data.conference.getDaysAsText(),
                            ),
                            preferredSize: Size.fromHeight(50),
                          ),
                        ),
                        body: snapshot.data.buildRoomLayout(context),
                      ),
                    );
                  }
                }));
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
                            DesignConstants.lightPrimaryColor),
                      ),
                      Container(
                        child: Text('Loading Fahrplan'),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
