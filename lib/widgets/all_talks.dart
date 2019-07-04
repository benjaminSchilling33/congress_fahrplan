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
    return new MaterialApp(
      theme: new ThemeData.dark(),
      title: 'Congress Fahrplan',
      home: new DefaultTabController(
        length: 4,
        child: new Scaffold(
          appBar: new AppBar(
            backgroundColor: DesignConstants.darkPrimaryColor,
            title: new Text('Congress Fahrplan'),
            leading: Ink(
              child: IconButton(
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
              child: FutureBuilder<Fahrplan>(
                future: fahrplan,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TabBar(
                        indicatorColor: DesignConstants.lightPrimaryColor,
                        tabs: snapshot.data.conference.getDaysAsText());
                  } else if (snapshot.hasError) {
                    return Text('Error');
                  }
                  return Text('');
                },
              ),
              preferredSize: Size.fromHeight(50),
            ),
          ),
          body: FutureBuilder<Fahrplan>(
            future: fahrplan,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                favorites.initializeProvider(snapshot.data);
                return snapshot.data.build(context);
              } else if (snapshot.hasError) {
                return Text('Error');
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      DesignConstants.lightPrimaryColor),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
