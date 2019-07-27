/*
congress_fahrplan
This is the dart file contains the FahrplanDrawer StatelessWidget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';

import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/widgets/favorites.dart';
import 'package:congress_fahrplan/widgets/all_talks.dart';
import 'package:congress_fahrplan/widgets/flat_icon_text_button.dart';

class FahrplanDrawer extends StatelessWidget {
  final Future<Fahrplan> fahrplan;
  final Text title;

  FahrplanDrawer({this.fahrplan, this.title});

  @override
  build(BuildContext context) {
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
                          return AllTalksWidget(
                            fahrplan: fahrplan,
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
                        builder: (context) => Favorites(
                          fahrplan: fahrplan,
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
