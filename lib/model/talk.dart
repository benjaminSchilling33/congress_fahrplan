/*
congress_fahrplan
This is the dart file containing the Talk StatelessWidget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2021 Benjamin Schilling
*/

import 'package:congress_fahrplan/main.dart';
import 'package:congress_fahrplan/model/person.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// The Talk widget stores all data about it and build a card with all data relevant for it.
class Talk extends StatelessWidget {
  DateTime? day;
  final int? id;
  final String? title;
  final String? track;
  final String? subtitle;
  final String? abstract;
  final String? start;
  final String? duration;
  final String? room;
  final String? language;
  final DateTime? date;
  final String? url;
  final List<Person>? persons;
  final bool? doNotRecord;
  final bool? doNotStream;
  bool? favorite;

  Talk(
      {this.id,
      this.title,
      this.track,
      this.subtitle,
      this.abstract,
      this.start,
      this.duration,
      this.room,
      this.date,
      this.language,
      this.url,
      this.persons,
      this.doNotRecord,
      this.doNotStream,
      this.favorite});

  factory Talk.fromJson(var json, String room) {
    return Talk(
      id: json['id'] != null ? json['id'] : 0,
      title: json['title'] != null ? json['title'] : "",
      track: json['track'] != null ? json['track'] : "",
      subtitle: json['subtitle'] != null ? json['subtitle'] : "",
      abstract: json['abstract'] != null
          ? json['abstract']
          : (json['description'] != null ? json['description'] : ""),
      start: json['start'] != null ? json['start'] : "",
      duration: json['duration'] != null ? json['duration'] : "",
      room: room,
      language: json['language'] != null ? json['language'] : "",
      date: DateTime.parse(json['date']),
      url: json['url'] != null ? json['url'] : "",
      persons:
          json['persons'] != null ? jsonToPersonList(json['persons']) : null,
      doNotRecord:
          json['do_not_record'] != null ? json['do_not_record'] : false,
      doNotStream:
          json['do_not_stream'] != null ? json['do_not_stream'] : false,
      favorite: false,
    );
  }

  static List<Person> jsonToPersonList(var json) {
    List<Person> persons = [];
    for (var j in json) {
      persons.add(Person.fromJson(j));
    }
    return persons;
  }

  void setDay(DateTime d) {
    this.day = d;
  }

  @override
  build(BuildContext context) {
    return Card(
      child: Semantics(
        child: ListTile(
          title: Semantics(
            label: 'Talk title, $title',
            child: ExcludeSemantics(
              child: Text(
                title!,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          subtitle: getCardSubtitle(),
          leading: Ink(
            child: Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) => IconButton(
                tooltip: "Add talk $title to favorites.",
                icon: Icon(
                  favorite! ? Icons.favorite : Icons.favorite_border,
                ),
                color: FahrplanColors.primary(),
                onPressed: () {
                  favoriteProvider.favoriteTalk(this, day!);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: favorite == true
                        ? Text(
                            '\"$title\" added to favorites.',
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            '\"$title\" removed from favorites.',
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    action: SnackBarAction(
                      label: "Revert",
                      onPressed: () =>
                          favoriteProvider.favoriteTalk(this, day!),
                    ),
                    duration: Duration(seconds: 2),
                  ));
                },
              ),
            ),
          ),
          trailing: Ink(
            decoration: ShapeDecoration(
              shape: CircleBorder(),
            ),
            child: IconButton(
              tooltip: "Show talk $title details.",
              icon: Icon(
                Icons.info,
                color: FahrplanColors.highlight(),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    backgroundColor: FahrplanColors.background(),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(
                        width: 2.0,
                        color: FahrplanColors.accent1(),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    title: Text('$title'),
                    children: <Widget>[
                      BlockSemantics(
                        child: Column(
                          children: getDetails(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Semantics(
                            label: 'Copy abstract.',
                            child: IconButton(
                              icon: Icon(Icons.content_copy),
                              color: FahrplanColors.primary(),
                              tooltip: 'Copy abstract.',
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: abstract!));
                              },
                            ),
                          ),
                          Semantics(
                            label: 'Share $title',
                            child: ExcludeSemantics(
                              child: IconButton(
                                icon: Icon(
                                  Icons.share,
                                ),
                                color: FahrplanColors.primary(),
                                tooltip: 'Share talk.',
                                onPressed: () => SharePlus.instance.share(
                                    ShareParams(
                                        text: 'Check out this talk: $url')),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Semantics getCardSubtitle() {
    String textString = '';

    textString = textString +
        ('$start' != ''
            ? ('$room' != '' ? '$start' + ' - ' : '$start')
            : ' - ');
    textString = textString +
        ('$room' != '' ? ('$track' != '' ? '$room' + ' - ' : '$room') : ' - ');
    textString = textString +
        ('$track' != ''
            ? ('$language' != '' ? '$track' + ' - ' : '$track')
            : ' - ');
    textString = textString + ('$language' != '' ? '$language' : '');
    textString = textString + (doNotRecord == true ? ' - No rec.' : '');
    textString = textString + (doNotStream == true ? ' - No stream' : '');
    return Semantics(
      label: 'Start $start, Room $room, Track $track, Language $language',
      child: ExcludeSemantics(
        child: Text(
          textString,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
          ),
        ),
      ),
    );
  }

  List<Widget> getDetails() {
    List<Widget> widgets = [];

    /// Add the subtitle
    if (subtitle != '') {
      widgets.add(
        Semantics(
          label: 'Subtitle $subtitle',
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text(
              '$subtitle',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
        ),
      );
    }

    /// Add the start details
    if (start != '') {
      widgets.add(
        Semantics(
          label: 'Start $start',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.access_time,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Text(
                  '$start',
                ),
              ],
            ),
          ),
        ),
      );
    }

    /// Add the duration details
    if (duration != '') {
      widgets.add(
        Semantics(
          label: 'Duration $duration',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.hourglass_empty,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Text(
                  '$duration',
                ),
              ],
            ),
          ),
        ),
      );
    }

    /// Add the room details
    if (room != '') {
      widgets.add(
        Semantics(
          label: 'Room $room',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.room,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Text(
                  '$room',
                ),
              ],
            ),
          ),
        ),
      );
    }

    /// Add the track details
    if (track != '') {
      widgets.add(
        Semantics(
          label: 'Track $track',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.school,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Text(
                  '$track',
                ),
              ],
            ),
          ),
        ),
      );
    }

    /// Add the language details
    if (language != '') {
      widgets.add(
        Semantics(
          label: 'Language $language',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.translate,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Text(
                  '$language',
                ),
              ],
            ),
          ),
        ),
      );
    }

    /// Add the url details
    if (url != '') {
      widgets.add(
        Semantics(
          label: 'Open Talk details in Browser',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.open_in_browser,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Expanded(
                  child: Linkify(
                    linkStyle: TextStyle(
                      color: FahrplanColors.highlight(),
                    ),
                    onOpen: (link) async {
                      launchUrlInternal(link.url);
                    },
                    text: "$url",
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    /// Add the persons details
    if (persons!.length > 0) {
      for (Person p in persons!) {
        widgets.add(Semantics(
          label: 'Presenter ${p.publicName}',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.group,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Text(p.publicName!.length > 20
                    ? '${p.publicName!.substring(0, 19)}...'
                    : '${p.publicName}'),
              ],
            ),
          ),
        ));
      }
    }

    /// Add the recording details
    if (doNotRecord != '') {
      widgets.add(
        Semantics(
          label: 'Recording $doNotRecord',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.local_movies,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Text(doNotRecord! ? 'No recording' : 'Recorded'),
              ],
            ),
          ),
        ),
      );
    }

    /// Add the recording details
    if (doNotStream != '') {
      widgets.add(
        Semantics(
          label: 'Streaming $doNotStream',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.broadcast_on_home,
                    color: FahrplanColors.primary(),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Text(doNotStream! ? 'No Streaming' : 'Streamed'),
              ],
            ),
          ),
        ),
      );
    }

    /// Add the abstract text
    if (abstract != '') {
      widgets.add(
        Semantics(
          label: 'Abstract $abstract',
          child: ExcludeSemantics(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Abstract: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('$abstract'),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  launchUrlInternal(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
