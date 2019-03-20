import 'package:flutter/material.dart';

const GreenMain = Color.fromRGBO(22, 227, 167, 1);
const GreenSecondMain = Color.fromRGBO(49, 243, 211, 1);

const GreenGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0, 0.9],
  colors: [
    GreenMain,
    GreenSecondMain
  ],
);

const BlueMain = Color.fromRGBO(110, 180, 254, 1);
const BlueSecond = Color.fromRGBO(130, 233, 255, 1);

const BlueGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.1, 0.9],
  colors: [
    BlueMain,
    BlueSecond
  ],
);

const YellowMain = Color.fromRGBO(254, 204, 101, 1);
const YellowSecond = Color.fromRGBO(255, 178, 127, 1);

const YellowGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.1, 0.9],
  colors: [
    YellowMain,
    YellowSecond
  ],
);

const RedMain = Color.fromRGBO(255, 99, 88, 1);
const RedSecond = Color.fromRGBO(254, 74, 76, 1);

const RedGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.1, 0.9],
  colors: [
    RedMain,
    RedSecond
  ],
);

const GreyGradient = LinearGradient(
  stops: [1],
  colors: [
    Colors.grey
  ],
);

// reminder colors

// fertilize

const BrownMain = Color.fromRGBO(199, 144, 129, 1);
const BrownSecond = Color.fromRGBO(223, 165, 121, 1);

const BrownGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.1, 0.9],
  colors: [
    BrownMain,
    BrownSecond
  ],
);

// water

const ReminderBlueMain = Color.fromRGBO(138, 229, 252, 1);
const ReminderBlueSecond = Color.fromRGBO(85, 181, 249, 1);

const ReminderBlueGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.1, 1],
  colors: [
    ReminderBlueSecond,
    ReminderBlueMain,
  ],
);

// rotate

const ReminderPurpleMain = Color.fromRGBO(196, 147, 246, 1);
const ReminderPurpleSecond = Color.fromRGBO(154, 158, 249, 1);

const ReminderPurpleGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.1, 1],
  colors: [
    ReminderPurpleMain,
    ReminderPurpleSecond,
  ],
);
