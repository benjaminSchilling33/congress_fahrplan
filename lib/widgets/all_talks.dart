/*
congress_fahrplan
This is the dart file containing the AllTalks screen StatelessWidget
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';

class AllTalks extends StatelessWidget {
  ThemeData theme;

  AllTalks({Key key, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var favorites = Provider.of<FavoriteProvider>(context);
    return new MaterialApp(
      theme: theme,
      title: favorites.fahrplan.getFahrplanTitle(),
      home: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            ///Portrait Orientation
            return favorites.fahrplan.buildDayLayout(context);
          } else {
            ///Landscape Orientation
            return favorites.fahrplan.buildRoomLayout(context);
          }
        },
      ),
    );
  }
}
