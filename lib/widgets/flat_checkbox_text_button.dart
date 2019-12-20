/*
congress_fahrplan
This is the dart file containing the FlatIconTextButton StatelessWidget used by the FahrplanDrawer widget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:flutter/material.dart';

class FlatCheckBoxTextButton extends StatelessWidget {
  final bool value;
  final String text;
  final Function onPressed;

  FlatCheckBoxTextButton({this.value, this.text, this.onPressed});

  @override
  build(BuildContext context) {
    return FlatButton(
        child: Semantics(
          label: 'Load complete fahrplan checkbox',
          child: ExcludeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Checkbox(
                    value: value,
                    onChanged: null,
                    checkColor: Theme.of(context).toggleableActiveColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    text,
                    style: onPressed != null
                        ? Theme.of(context).textTheme.subtitle
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        onPressed: onPressed);
  }
}
