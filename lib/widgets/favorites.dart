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
