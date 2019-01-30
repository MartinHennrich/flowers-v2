import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Name extends StatelessWidget {
  final Function(String) onSave;
  final String prefilled;

  Name({
    @required this.onSave,
    this.prefilled = ''
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 34),
      child: TextFormField(
        onSaved: (form) {
          onSave(form);
        },
        maxLength: 12,
        initialValue: prefilled,
        decoration: InputDecoration(
          hintText: 'Batman?',
          labelText: 'Name',
        ),
        validator: (String value) {
          if (value.length < 2) {
            return 'Minimun of 2 chars';
          }

          if (value.length > 12) {
            return 'Max of 12 chars';
          }

          return null;
        },
      )
    );
  }
}
