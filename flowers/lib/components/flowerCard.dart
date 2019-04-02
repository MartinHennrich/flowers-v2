import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../flower.dart';
import '../reminders.dart';
import '../utils/colors.dart';
import '../utils/reminderHelpers.dart';

class FlowerCard extends StatelessWidget {
  final Flower flower;
  final bool disabled;
  final bool withHero;
  final bool statusBar;
  final bool withReminderBar;
  final bool isSelected;
  final Function(Flower flower) onPress;
  final Function(Flower flower) onLongPress;

  FlowerCard({
    this.flower,
    this.onPress,
    this.disabled = false,
    this.withHero = false,
    this.statusBar = true,
    this.withReminderBar = false,
    this.onLongPress,
    this.isSelected = false,
  });

  LinearGradient _getColor(Flower flower) {
    if (disabled) {
      return BlueGradient;
    }

   return getColorGradientForFlower(flower);
  }

  Color _getColor2(Flower flower) {
    if (disabled) {
      return BlueMain;
    }

    return getColorForFlower(flower);
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

  Widget _getReminderIcon() {
    List<Reminder> reminders = flower.reminders.getSortedRemindersByTime(
      DateTime.now(),
      myReminders: flower.reminders.getRemindersThatNeedAction(DateTime.now())
    );
    if (reminders.length == 0) {
      return Container();
    }

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: reminders.map((reminder) {
          return Container(
            margin: EdgeInsets.only(right: 6),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400],
                  offset: Offset(0.0, 1.5),
                  blurRadius: 1.5,
                ),
              ]
            ),
            child: Center(child: Icon(
              getReminderIcon(reminder),
              size: 20,
              color: Colors.black.withAlpha(100)
            ))
          );
        }).toList()
      )
    );
  }

  Widget _getSelectedOverlay() {
    return Positioned(
      left: 0,
      top: 16,
      child: Container(
        width: 144,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(200),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Center(
          child: Icon(
            Icons.check,
            size: 64,
            color: Colors.white,
          ),
        ),
      )
    );
  }

  Widget _withReminderBar(Widget widget) {
    return withReminderBar
      ? Stack(
          children: <Widget>[
            widget,
            isSelected
              ? _getSelectedOverlay()
              : Container(),
            Positioned(
              left: 6,
              top: 20,
              child: _getReminderIcon(),
            ),
          ],
        )
      : widget;
  }

  @override
  Widget build(BuildContext context) {
    Color timeBasedColor = _getColor2(flower);

    return _withHero(
      GestureDetector(
        onLongPress: () {
          if (onLongPress != null) {
            onLongPress(flower);
          }
        },
        onTap: disabled ? null : () {
          onPress(flower);
        },
        child: _withReminderBar(Container(
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
        ))
      ));
  }
}
