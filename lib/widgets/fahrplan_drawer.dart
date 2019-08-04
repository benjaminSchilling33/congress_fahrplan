/*
congress_fahrplan
This is the dart file contains the FahrplanDrawer StatelessWidget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:congress_fahrplan/widgets/favorites.dart';
import 'package:congress_fahrplan/widgets/all_talks.dart';
import 'package:congress_fahrplan/widgets/flat_icon_text_button.dart';
import 'package:congress_fahrplan/widgets/flat_checkbox_text_button.dart';

import 'package:congress_fahrplan/provider/favorite_provider.dart';

class FahrplanDrawer extends StatelessWidget {
  final Text title;

  FahrplanDrawer({this.title});

  @override
  build(BuildContext context) {
    var favorites = Provider.of<FavoriteProvider>(context);
    return Container(
      color: Colors.black54,
      child: ListView(
        children: <Widget>[
          Container(padding: EdgeInsets.fromLTRB(20, 30, 0, 5), child: title),
          FlatIconTextButton(
            icon: Icons.calendar_today,
            text: 'Overview',
            onPressed: title.data == 'Favorites'
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AllTalks(
                            theme: Theme.of(context),
                          );
                        },
                      ),
                    );
                  }
                : null,
          ),
          FlatIconTextButton(
            icon: Icons.favorite,
            text: 'Favorites',
            onPressed: title.data == 'Overview'
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favorites(),
                      ),
                    );
                  }
                : null,
          ),
          FlatCheckBoxTextButton(
            value: favorites.fahrplan.settings.getLoadFullFahrplan(),
            onPressed: () {
              favorites.fahrplan.settings.setLoadFullFahrplan(
                  !favorites.fahrplan.settings.getLoadFullFahrplan(), context);
            },
            text: 'Load complete Fahrplan',
          ),
        ],
      ),
    );
  }
}
