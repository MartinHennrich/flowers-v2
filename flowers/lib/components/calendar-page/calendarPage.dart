import 'package:flutter/material.dart';

import '../../flower.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendarPageState();
  }
}

class CalendarPageState extends State<CalendarPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Calendar'),
      ),

      body: Container(
        padding: EdgeInsets.all(16),
        child: Text('hej!')
      )
    );
  }
}
