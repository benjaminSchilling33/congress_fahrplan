/*
congress_fahrplan
This is the dart file containing the FahrplanDrawer StatelessWidget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2021 Benjamin Schilling
*/

import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/utilities/fahrplan_fetcher.dart';
import 'package:congress_fahrplan/widgets/all_talks.dart';
import 'package:congress_fahrplan/widgets/favorites.dart';
import 'package:congress_fahrplan/widgets/flat_checkbox_text_button.dart';
import 'package:congress_fahrplan/widgets/flat_icon_text_button.dart';
import 'package:congress_fahrplan/widgets/sync_calendar.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class FahrplanDrawer extends StatelessWidget {
  final String? title;
  FahrplanDrawer({this.title});

  @override
  build(BuildContext context) {
    var favorites = Provider.of<FavoriteProvider>(context);
    String acronym = favorites.fahrplan!.conference!.acronym!;

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text(
          '$title',
          style: Theme.of(context).textTheme.headline6,
        ),
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
          title! == 'Favorites'
              ? FlatIconTextButton(
                  icon: Icons.calendar_today,
                  text: 'Show Overview',
                  onPressed: () {
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
                  },
                )
              : FlatIconTextButton(
                  icon: Icons.favorite,
                  text: 'Show Favorites',
                  onPressed: () {
                    print('Show favorites pressed.');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favorites(),
                      ),
                    );
                  },
                ),
          FahrplanFetcher.multipleSchedules
              ? FlatCheckBoxTextButton(
                  value: favorites.fahrplan!.settings!.getLoadFullFahrplan(),
                  text: 'Load complete Fahrplan',
                  onPressed: () {
                    favorites.fahrplan!.settings!.setLoadFullFahrplan(
                        !favorites.fahrplan!.settings!.getLoadFullFahrplan(),
                        context);
                  },
                )
              : Container(),
          FlatIconTextButton(
            icon: Icons.sync,
            text: 'Sync favorites with calendar',
            onPressed: () => showSyncCalendar(context, favorites),
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
                'https://github.com/benjaminSchilling33/congress_fahrplan/wiki/Congress-Fahrplan-Datenschutzerkl%C3%A4rung-(Privacy-Policy)'),
          ),
          FlatIconTextButton(
            icon: Icons.bug_report,
            text: 'Report Bug',
            onPressed: () => launchUrl(
                'https://github.com/benjaminSchilling33/congress_fahrplan/issues'),
          ),
          FlatIconTextButton(
            icon: Icons.color_lens,
            text: 'Design adapted from\nrC3 design by kreatur.works',
            onPressed: () => launchUrl('https://kreatur.works/'),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
            child: Text(
              'Version: ' + favorites.packageVersion,
            ),
          ),
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

  showSyncCalendar(BuildContext context, FavoriteProvider favorites) async {
    DeviceCalendarPlugin deviceCalendar = DeviceCalendarPlugin();
    Result<bool> permissionsAvailable = await deviceCalendar.hasPermissions();
    if (!permissionsAvailable.data!) {
      permissionsAvailable = await deviceCalendar.requestPermissions();
    }
    if (permissionsAvailable.data!) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          contentPadding: EdgeInsets.all(10),
          title: Text('Sync favorites'),
          children: <Widget>[
            SyncCalendar(
              calendarPlugin: deviceCalendar,
              provider: favorites,
            ),
          ],
        ),
      );
    }
  }
}
