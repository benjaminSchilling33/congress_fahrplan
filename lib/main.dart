/*
congress_fahrplan
This is the dart file containing the main method, the ThemeWrapper and the CongressFahrplanApp class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 -2021 Benjamin Schilling
*/

import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/widgets/all_talks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ThemeWrapper());
}

class FahrplanColors {
  static Color base_black() {
    return Color(0xff000000);
  }

  static Color base_white() {
    return Color(0xffffffff);
  }

  static Color base_grey_light() {
    return Color(0xffd9d9d9);
  }

  static Color base_grey_medium() {
    return Color(0xffaaaaaa);
  }

  static Color base_medium_dark_grey() {
    return Color(0xff7a7a7a);
  }

  static Color base_dark_grey() {
    return Color(0xff202020);
  }

  static Color primary_accent_light_blue() {
    return Color(0xff2d42ff);
  }

  static Color primary_accent_dark_blue() {
    return Color(0xff0b1575);
  }

  static Color primary_accent_light_red() {
    return Color(0xffde4040);
  }

  static Color primary_accent_dark_red() {
    return Color(0xff561010);
  }

  static Color primary_accent_light_green() {
    return Color(0xff79ff5e);
  }

  static Color primary_accent_dark_green() {
    return Color(0xff2b8d18);
  }

  static Color secondary_accent_light_turquoise() {
    return Color(0xff29ffff);
  }

  static Color secondary_accent_dark_turquoise() {
    return Color(0xff006b6b);
  }

  static Color secondary_accent_light_purple() {
    return Color(0xffde37ff);
  }

  static Color secondary_accent_dark_purple() {
    return Color(0xff66007a);
  }

  static Color secondary_accent_light_yellow() {
    return Color(0xfff6f675);
  }

  static Color secondary_accent_dark_yellow() {
    return Color(0xff757501);
  }
}

class ThemeWrapper extends StatelessWidget {
  ThemeWrapper({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Congress Fahrplan',
      theme: ThemeData(
        fontFamily: 'VcrOcdFaux',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          background: FahrplanColors.base_black(),
          brightness: Brightness.dark,
          primary: FahrplanColors.base_white(),
        ),
        tabBarTheme: TabBarTheme(
          indicator: UnderlineTabIndicator(),
        ),
        primaryColor: FahrplanColors.base_white(),
        primaryColorLight: FahrplanColors.base_white(),
        primaryColorDark: FahrplanColors.base_black(),
        indicatorColor: FahrplanColors.primary_accent_light_blue(),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: FahrplanColors.base_white(),
          ),
          bodyMedium: TextStyle(
            color: FahrplanColors.base_white(),
          ),
          bodyLarge: TextStyle(
            color: FahrplanColors.base_white(),
          ),
          titleSmall: TextStyle(
            color: FahrplanColors.base_white(),
          ),
          titleMedium: TextStyle(
            color: FahrplanColors.base_white(),
          ),
          headlineMedium: TextStyle(
            color: FahrplanColors.base_white(),
          ),
          bodySmall: TextStyle(
            color: FahrplanColors.base_white(),
          ),
          labelSmall: TextStyle(
            color: FahrplanColors.base_white(),
          ),
          headlineSmall: TextStyle(
            color: FahrplanColors.base_white(),
          ),
        ),
        cardTheme: CardTheme(
          color: FahrplanColors.base_black(),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
              width: 2.0,
              color: FahrplanColors.primary_accent_dark_blue(),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: FahrplanColors.base_black(),
          actionTextColor: FahrplanColors.primary_accent_light_green(),
          contentTextStyle: TextStyle(
            color: FahrplanColors.primary_accent_light_green(),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              side: BorderSide(
                  width: 2.0,
                  color: FahrplanColors.primary_accent_dark_green())),
          elevation: 30,
        ),
        appBarTheme: AppBarTheme(
          color: FahrplanColors.base_black(),
          iconTheme: IconThemeData(
            color: FahrplanColors.primary_accent_light_blue(),
          ),
        ),
        iconTheme: IconThemeData(
          color: FahrplanColors.primary_accent_light_blue(),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return FahrplanColors.primary_accent_light_blue();
              }
              return null;
            },
          ),
        ),
        dialogBackgroundColor: FahrplanColors.base_black(),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return FahrplanColors.primary_accent_light_blue();
              }
              return null;
            },
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return FahrplanColors.primary_accent_light_blue();
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return FahrplanColors.primary_accent_light_blue();
            }
            return null;
          }),
        ),
      ),
      home: CongressFahrplanApp(key: key),
    );
  }
}

class CongressFahrplanApp extends StatelessWidget {
  CongressFahrplanApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) => FutureBuilder<Fahrplan>(
          future: favoriteProvider.futureFahrplan,
          builder: (context, AsyncSnapshot<Fahrplan> snapshot) {
            if (snapshot.hasData) {
              favoriteProvider.initializeProvider(snapshot.data!);
              if (favoriteProvider.fahrplan!.fetchState ==
                  FahrplanFetchState.successful) {
                return AllTalks(
                  theme: Theme.of(context),
                );
              } else {
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: FahrplanColors.base_black(),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/icon.png'),
                        Text(
                          'Could not fetch Fahrplan!',
                        ),
                        Text(
                          favoriteProvider.fahrplan!.fetchMessage!,
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: FahrplanColors.base_black(),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
                          child: Image.asset('assets/icon.png')),
                      CircularProgressIndicator(),
                      Container(
                        child: Text('Fetching Fahrplan'),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
