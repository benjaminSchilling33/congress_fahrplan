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
  static Color background() {
    return Color(0xff141414);
  }

  static Color base_grey_medium() {
    return Color(0xfffaf5f5);
  }

  static Color base_medium_dark_grey() {
    return Color(0xfffaf5f5);
  }

  static Color base_dark_grey() {
    return Color(0xfffaf5f5);
  }

  static Color primary() {
    return Color(0xff00ff00);
  }

  static Color highlight() {
    return Color(0xff9673ff);
  }

  static Color accent1() {
    return Color(0xffff3719);
  }

  static Color accent2() {
    return Color(0xff66f2ff);
  }

  static Color accent3() {
    return Color(0xff66f2ff);
  }

  static Color accent4() {
    return Color(0xff66f2ff);
  }

  static Color accent5() {
    return Color(0xff66f2ff);
  }
/*
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
  */
}

class ThemeWrapper extends StatelessWidget {
  ThemeWrapper({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Congress Fahrplan',
      theme: ThemeData(
        fontFamily: 'OfficeSans',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          surface: FahrplanColors.background(),
          brightness: Brightness.dark,
          primary: FahrplanColors.highlight(),
        ),
        tabBarTheme: TabBarThemeData(
          indicator: UnderlineTabIndicator(),
          indicatorColor: FahrplanColors.accent2(),
        ),
        primaryColor: FahrplanColors.primary(),
        primaryColorLight: FahrplanColors.highlight(),
        primaryColorDark: FahrplanColors.accent1(),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          bodyMedium: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          bodyLarge: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          titleSmall: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          titleMedium: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          headlineMedium: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          bodySmall: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          labelSmall: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          headlineSmall: TextStyle(
            color: FahrplanColors.highlight(),
          ),
        ),
        cardTheme: CardThemeData(
          color: FahrplanColors.background(),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
              width: 2.0,
              color: FahrplanColors.accent3(),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: FahrplanColors.background(),
          actionTextColor: FahrplanColors.accent1(),
          contentTextStyle: TextStyle(
            color: FahrplanColors.highlight(),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              side: BorderSide(width: 2.0, color: FahrplanColors.accent1())),
          elevation: 30,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: FahrplanColors.background(),
          iconTheme: IconThemeData(
            color: FahrplanColors.accent1(),
          ),
        ),
        iconTheme: IconThemeData(
          color: FahrplanColors.accent1(),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return FahrplanColors.accent2();
              }
              return null;
            },
          ),
        ),
        dialogBackgroundColor: FahrplanColors.background(),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return FahrplanColors.accent2();
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
              return FahrplanColors.accent2();
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null;
            }
            if (states.contains(MaterialState.selected)) {
              return FahrplanColors.accent2();
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
                    backgroundColor: FahrplanColors.background(),
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
                  backgroundColor: FahrplanColors.background(),
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
