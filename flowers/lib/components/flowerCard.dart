import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../flower.dart';
import '../constants/colors.dart';

import '../utils/colors.dart';

class FlowerCard extends StatelessWidget {
  final Flower flower;
  final bool disabled;
  final bool withHero;
  final bool statusBar;
  final Function(Flower flower) onPress;

  FlowerCard({
    this.flower,
    this.onPress,
    this.disabled = false,
    this.withHero = false,
    this.statusBar = true,
  });

  LinearGradient _getColor(Flower flower) {

    if (disabled) {
      return BlueGradient;
    }
    Reminder clostToDate = flower.reminders.getClosestDate(DateTime.now());
    if (clostToDate == null) {
      return GreenGradient;
    }
    return getColorBasedOnTime(clostToDate.nextTime, clostToDate.lastTime);
  }

  Widget _withHero(Widget widget) {
    return withHero
      ? Hero(
        tag: flower.key,
        child: widget,
      )
      : widget;
  }

  Widget _getStatusBar(Color timeBasedColor) {
    Color _kKeyUmbraOpacity = timeBasedColor.withAlpha(51);
    Color _kKeyPenumbraOpacity = timeBasedColor.withAlpha(36);
    Color _kAmbientShadowOpacity = timeBasedColor.withAlpha(31);
    if (!statusBar) {
      return Container();
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 50,
            alignment: Alignment(-1.0, 0.0),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              gradient: _getColor(flower),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: _kKeyUmbraOpacity),
                BoxShadow(offset: Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
                BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
              ],
            ),
            child: Text(
              flower.name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              )
            )
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    Color timeBasedColor = getColorBasedOnTime2(flower.reminders.water.nextTime, flower.reminders.water.lastTime);

    return _withHero(
      GestureDetector(
        onTap: disabled ? null : () {
          onPress(flower);
        },
        child: Container(
          width: 144,
          height: 170,
          margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
          decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
              image: CachedNetworkImageProvider(flower.imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: _getStatusBar(timeBasedColor)
        )
      ));
  }
}
