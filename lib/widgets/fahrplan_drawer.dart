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
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class FahrplanDrawer extends StatelessWidget {
  final Text title;

  FahrplanDrawer({this.title});

  @override
  build(BuildContext context) {
    var favorites = Provider.of<FavoriteProvider>(context);
    String acronym = favorites.fahrplan.conference.acronym;
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: title,
        leading: Semantics(
          label: 'Close menu',
          child: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          FlatIconTextButton(
            icon: Icons.calendar_today,
            text: 'Show Overview',
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
            text: 'Show Favorites',
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
            text: 'Load complete Fahrplan',
            onPressed: () {
              favorites.fahrplan.settings.setLoadFullFahrplan(
                  !favorites.fahrplan.settings.getLoadFullFahrplan(), context);
            },
          ),
          FlatIconTextButton(
            icon: Icons.share,
            text: 'Share this app',
            onPressed: () => Share.share(
                'Check out the $acronym Fahrplan app: https://play.google.com/store/apps/details?id=de.delusionsoftware.congress_fahrplan'),
          ),
          FlatIconTextButton(
            icon: Icons.security,
            text: 'Show Data Privacy Policy',
            onPressed: () => launchUrl(
                'https://delusionsoftware.de/congress-fahrplan-datenschutzerklarung-privacy-policy/'),
          ),
          FlatIconTextButton(
            icon: Icons.bug_report,
            text: 'Report Bug',
            onPressed: () => launchUrl(
                'https://github.com/benjaminSchilling33/congress_fahrplan/issues'),
          )
        ],
      ),
    );
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
