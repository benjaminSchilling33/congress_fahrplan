/*
congress_fahrplan
This is the dart file containing the FlatIconTextButton StatelessWidget used by the FahrplanDrawer widget.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2021 Benjamin Schilling
*/

import 'package:flutter/material.dart';

class FlatCheckBoxTextButton extends StatelessWidget {
  final bool? value;
  final String? text;
  final Function? onPressed;

  FlatCheckBoxTextButton({this.value, this.text, this.onPressed});

  @override
  build(BuildContext context) {
    return TextButton(
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
                    checkColor: Theme.of(context).primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    text!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        onPressed: () => onPressed!);
  }
}
