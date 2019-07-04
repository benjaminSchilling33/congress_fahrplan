import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:congress_fahrplan/widgets/all_talks.dart';
import 'package:congress_fahrplan/provider/favorite_provider.dart';
import 'package:congress_fahrplan/model/fahrplan.dart';
import 'package:congress_fahrplan/utilities/network_communication.dart';

void main() {
  runApp(CongressFahrplanApp(
    fahrplan: NetworkCommunication.fetchFahrplan(),
  ));
}

class CongressFahrplanApp extends StatelessWidget {
  Future<Fahrplan> fahrplan;

  CongressFahrplanApp({Key key, this.fahrplan}) : super(key: key);

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => FavoriteProvider(),
      child: MaterialApp(
        title: 'Congress Fahrplan',
        initialRoute: '/',
        routes: {
          '/': (context) => AllTalks(
                fahrplan: fahrplan,
              ),
        },
      ),
    );
  }
}
