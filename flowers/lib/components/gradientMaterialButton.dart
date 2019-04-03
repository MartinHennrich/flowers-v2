import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final ShapeBorder shape;
  final Function onPressed;
  final BorderRadius buttonRadius;
  final bool shadow;

  const GradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
    this.shape,
    this.buttonRadius = const BorderRadius.all(Radius.circular(0)),
    this.shadow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    Color _kKeyUmbraOpacity = color.withAlpha(51);
    Color _kKeyPenumbraOpacity = color.withAlpha(36);
    Color _kAmbientShadowOpacity = color.withAlpha(31);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: this.buttonRadius,
        boxShadow: shadow ? <BoxShadow>[
          BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: _kKeyUmbraOpacity),
          BoxShadow(offset: Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
          BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        shape: this.shape,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: child,
          )),
      ),
    );
  }
}
