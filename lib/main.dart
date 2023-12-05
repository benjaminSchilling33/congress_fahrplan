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

class ThemeWrapper extends StatelessWidget {
  ThemeWrapper({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Congress Fahrplan',
      theme: ThemeData(
      brightness: Brightness.dark,
      backgroundColor: Color(0xff000000),
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(),
      ),
      primaryColorDark: Color(0xff000000),
      indicatorColor: Color(0xFF4D7FFA),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        bodyMedium: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        bodyLarge: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        titleSmall: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        titleMedium: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        headlineMedium: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        bodySmall: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        labelSmall: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        headlineSmall: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
      ),
      cardColor: Color(0xFF3b3b3b),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF4d4d4d),
        actionTextColor: Color(0xFF4D7FFA),
        contentTextStyle: TextStyle(
          color: Color(0xFFD0D0CE),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 30,
      ),
      appBarTheme: AppBarTheme(
        color: Color(0xFF1a1a1a),
        iconTheme: IconThemeData(
          color: Color(0xFF4D7FFA),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF4D7FFA),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF4D7FFA), brightness: Brightness.dark), checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) { return null; }
        if (states.contains(MaterialState.selected)) { return Color(0xFF4D7FFA); }
        return null;
      }),
    ), radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) { return null; }
        if (states.contains(MaterialState.selected)) { return Color(0xFF4D7FFA); }
        return null;
      }),
    ), switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) { return null; }
        if (states.contains(MaterialState.selected)) { return Color(0xFF4D7FFA); }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) { return null; }
        if (states.contains(MaterialState.selected)) { return Color(0xFF4D7FFA); }
        return null;
      }),
    ),
    ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Color(0xff000000),
        tabBarTheme: TabBarTheme(
          indicator: UnderlineTabIndicator(),
        ),
        primaryColorDark: Color(0xff000000),
        indicatorColor: Color(0xFF4D7FFA),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          bodyLarge: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          titleSmall: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          titleMedium: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          headlineMedium: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          bodySmall: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          labelSmall: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          headlineSmall: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
        ),
        cardColor: Color(0xFF3b3b3b),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF4d4d4d),
          actionTextColor: Color(0xFF4D7FFA),
          contentTextStyle: TextStyle(
            color: Color(0xFFD0D0CE),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          elevation: 30,
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFF1a1a1a),
          iconTheme: IconThemeData(
            color: Color(0xFF4D7FFA),
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF4D7FFA),
        ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF4D7FFA), brightness: Brightness.dark), checkboxTheme: CheckboxThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Color(0xFF4D7FFA); }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Color(0xFF4D7FFA); }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Color(0xFF4D7FFA); }
 return null;
 }),
 trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Color(0xFF4D7FFA); }
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
                      backgroundColor: Color(0xff000000),
                      body: Stack(
                        children: [
                          Image.asset('assets/background.jpg'),
                          Column(
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
                        ],
                      )),
                );
              }
            } else {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: Color(0xff000000),
                  body: Stack(
                    children: [
                      Image.asset('assets/background.jpg'),
                      Column(
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
