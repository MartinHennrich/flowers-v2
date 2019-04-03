import 'package:flutter/material.dart';

class CustomScrollColor extends StatelessWidget {
  final Widget child;
  final AxisDirection axisDirection;

  CustomScrollColor({
    this.child,
    this.axisDirection = AxisDirection.down
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: axisDirection,
        color: Colors.grey,
        child: child,
      )
    );
  }
}

