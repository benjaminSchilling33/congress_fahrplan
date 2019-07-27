/*
congress_fahrplan
This is the dart file contains the FlatIconTextButton StatelessWidget used by the FahrplanDrawer widget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';

class FlatIconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;

  FlatIconTextButton({this.icon, this.text, this.onPressed});

  @override
  build(BuildContext context) {
    return FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Icon(
                icon,
                color: onPressed != null
                    ? Theme.of(context).iconTheme.color
                    : null,
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  text,
                  style: onPressed != null
                      ? Theme.of(context).textTheme.subtitle
                      : null,
                )),
          ],
        ),
        onPressed: onPressed);
  }
}
