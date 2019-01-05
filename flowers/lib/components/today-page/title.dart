import 'package:flutter/material.dart';

class TodayPageTitle extends StatelessWidget {
  final String title;
  final double fontSize;

  TodayPageTitle({
    this.title,
    this.fontSize = 60
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 40),
      child: Text(title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 0, 0, 0.3)
        ),
      ),
    );
  }
}
