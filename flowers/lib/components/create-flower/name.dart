import 'dart:math';

import 'package:flutter/material.dart';

String getRandomName() {
  final Random random = Random();
  List<String> names = [
    'Batman',
    'Catwoman',
    'Cactus',
    'Trump? haha kidding maybe jon',
    'Barney',
    'Baymax',
    'Bigfoot',
    'Buzz lightyear',
    'Sparrow',
    'Sunflower',
    'Tomato 🍅',
    'Cucumber 🥒',
    'Chilli 🌶',
    'Hercules',
    'Hulk',
    'Iron Man',
    'That thing',
    '<3',
    '😍',
    '😎',
    '😬',
    '💩',
    '🥦',
    '🍆',
    '🥑',
    '🥕',
    '🍋',
    'Chandler',
    'Chanandler',
    'Rachel green',
    'DeVito',
    'Vader',
    'Mad',
    'Dr',
    'Poppins',
    'Gump',
    'Kong',
    'James Bond',
    'Jenny',
  ];

  return names[random.nextInt(names.length)] + '?';
}

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
        maxLength: 14,
        initialValue: prefilled,
        decoration: InputDecoration(
          hintText: getRandomName(),
          labelText: 'Name',
        ),
        validator: (String value) {
          if (value.length < 2) {
            return 'Minimun of 2 chars';
          }

          if (value.length > 14) {
            return 'Max of 14 chars';
          }

          return null;
        },
      )
    );
  }
}
