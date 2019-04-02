import 'package:flutter/material.dart';

import '../../../constants/enums.dart';
import '../../../flower.dart';
import '../../../reminders.dart';
import '../../../utils/firebase-redux.dart';
import './actionButton.dart';
import './allButton.dart';

class QuickActionBar extends StatefulWidget{
  final List<Flower> flowers;
  final Function onAction;

  QuickActionBar({
    this.flowers,
    this.onAction,
  });

  @override
  QuickActionBarState createState() {
    return QuickActionBarState();
  }
}

class QuickActionBarState extends State<QuickActionBar> {

  void _onAllActionPress() {
    widget.flowers.forEach((flower) {
      flower.reminders.getRemindersThatNeedAction(DateTime.now())
        .forEach((reminder) async {
          switch (reminder.type) {
            case ReminderType.Water:
                await waterFlower(flower, WaterAmount.Normal, SoilMoisture.Soil50);
              break;
            case ReminderType.Rotate:
                await rotateFlower(flower);
              break;
            case ReminderType.Fertilize:
                await fertilizeFlower(flower);
              break;
            default:
          }
        });
    });
    widget.onAction();
    Navigator.of(context).pop();
  }

  void _onAllPostponePress(int days) {
    widget.flowers.forEach((flower) {
      flower.reminders.getRemindersThatNeedAction(DateTime.now())
        .forEach((reminder) async {
          switch (reminder.type) {
            case ReminderType.Water:
                await postponeWatering(flower, SoilMoisture.Soil50);
              break;
            case ReminderType.Rotate:
                await postponeRotate(flower, days);
              break;
            case ReminderType.Fertilize:
                await postponeFertilize(flower, days);
              break;
            default:
          }
        });
    });
    widget.onAction();
    Navigator.of(context).pop();
  }

  void _onActionPress(ReminderType type, List<Flower> flowers) {
    switch (type) {
      case ReminderType.Water:
        flowers.forEach((flower) async {
          await waterFlower(flower, WaterAmount.Normal, SoilMoisture.Soil50);
        });
        break;
      case ReminderType.Rotate:
        flowers.forEach((flower) async {
          await rotateFlower(flower);
        });
        break;
      case ReminderType.Fertilize:
        flowers.forEach((flower) async {
          await fertilizeFlower(flower);
        });
        break;
      default:
    }
    widget.onAction();
    Navigator.of(context).pop();
  }

  void _onPostponePress(ReminderType type, List<Flower> flowers, int days) {
    switch (type) {
      case ReminderType.Water:
        flowers.forEach((flower) async {
          await postponeWatering(flower, SoilMoisture.Soil50);
        });
        break;
      case ReminderType.Rotate:
        flowers.forEach((flower) async {
          await postponeRotate(flower, days);
        });
        break;
      case ReminderType.Fertilize:
        flowers.forEach((flower) async {
          await postponeFertilize(flower, days);
        });
        break;
      default:
    }
    widget.onAction();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Map<ReminderType, List<String>> _availableReminders = {
      ReminderType.Water: [],
      ReminderType.Rotate: [],
      ReminderType.Fertilize: []
    };

    widget.flowers.forEach((flower) {
      flower.reminders.getRemindersThatNeedAction(DateTime.now()).forEach((reminder) {
        _availableReminders[reminder.type].add(flower.key);
      });
    });

    List<Widget> buttons = [];
    _availableReminders.forEach((key, value) {
      buttons.add(
        ActionButton(
          type: key,
          amount: value.length,
          keys: value,
          flowers: widget.flowers,
          onActionPress: _onActionPress,
          onPostponePress: _onPostponePress,
        )
      );
    });
    buttons.add(AllButton(
      amount: widget.flowers.length,
      onActionPress: _onAllActionPress,
      onPostponePress: _onAllPostponePress,
    ));

    return Container(
      height: 54,
      child: ListView(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        children: buttons
      )
    );
  }
}
