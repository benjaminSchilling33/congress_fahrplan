/*
congress_fahrplan
This is the dart file containing the FlatIconTextButton StatelessWidget used by the FahrplanDrawer widget.
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
        child: Semantics(
          label: '$text',
          child: ExcludeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: Icon(
                    icon,
                    color: onPressed != null
                        ? Theme.of(context).iconTheme.color
                        : null,
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Text(
                      text,
                      style: onPressed != null
                          ? Theme.of(context).textTheme.subtitle2
                          : null,
                    )),
              ],
            ),
          ),
        ),
        onPressed: onPressed);
  }
}
