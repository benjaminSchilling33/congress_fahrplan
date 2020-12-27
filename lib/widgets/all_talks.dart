/*
congress_fahrplan
This is the dart file containing the AllTalks screen StatelessWidget
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/utilities/fahrplan_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTalks extends StatelessWidget {
  final ThemeData theme;

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
            Future.delayed(
                Duration.zero, () => openOutdatedDialog(context, favorites));
            return favorites.fahrplan.buildDayLayout(context);
          } else {
            ///Landscape Orientation
            Future.delayed(
                Duration.zero, () => openOutdatedDialog(context, favorites));
            return favorites.fahrplan.buildRoomLayout(context);
          }
        },
      ),
    );
  }

  openOutdatedDialog(BuildContext context, FavoriteProvider provider) {
    /// Show only when URLs are outdated and notice has not been dismissed yet
    if ((FahrplanFetcher.oldUrls
                .contains(FahrplanFetcher.completeFahrplanUrl) ||
            FahrplanFetcher.oldUrls
                .contains(FahrplanFetcher.minimalFahrplanUrl)) &&
        !provider.oldTalkNoticeDismissed) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          contentPadding: EdgeInsets.all(10),
          title: Text(
              'The RC3 Fahrplan is not yet released, therefore the Fahrplan from last year is shown.'),
          children: <Widget>[
            Semantics(
              label: 'Dismiss',
              child: ExcludeSemantics(
                child: FlatButton(
                  onPressed: () {
                    provider.oldTalkNoticeDismissed = true;
                    Navigator.pop(context);
                  },
                  child: Text('Dismiss'),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
