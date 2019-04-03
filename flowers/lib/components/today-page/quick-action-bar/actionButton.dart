import 'package:flutter/material.dart';

import '../../../constants/availableReminders.dart';
import '../../../flower.dart';
import '../../../reminders.dart';
import '../multible-dialog/multibleDialog.dart';

class ActionButton extends StatelessWidget {
  final int amount;
  final ReminderType type;
  final List<String> keys;
  final List<Flower> flowers;
  final Function(ReminderType, List<Flower>) onActionPress;
  final Function(ReminderType, List<Flower>, int) onPostponePress;

  ActionButton({
    this.amount,
    this.type,
    this.keys,
    this.flowers,
    this.onActionPress,
    this.onPostponePress,
  });

  void _onTap(BuildContext context, String title) {
    List<Flower> flowersWithSelectedReminder = flowers
      .where((flower) => keys.contains(flower.key)).toList();

    showDialog(
      context: context,
      builder: (_) => MultibleDialog(
        amount: flowersWithSelectedReminder.length,
        actionTitle: title,
        onActionPress: () {
          onActionPress(type, flowersWithSelectedReminder);
        },
        onPostponePress: (int days) {
          onPostponePress(type, flowersWithSelectedReminder, days);
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (amount < 2) {
      return Container();
    }

    AvaiableReminder avaiableReminder = avaiableReminders
      .firstWhere((a) => a.reminderType == type);

    Color color = avaiableReminder.color;
    Color _kKeyUmbraOpacity = color.withAlpha(51);
    Color _kKeyPenumbraOpacity = color.withAlpha(36);
    Color _kAmbientShadowOpacity = color.withAlpha(31);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 4.0, spreadRadius: -1.0, color: _kKeyUmbraOpacity),
          BoxShadow(offset: Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
          BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 10.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
        ],
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      margin: EdgeInsets.only(left: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          onTap: () {
            _onTap(context, avaiableReminder.title);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: <Widget>[
                Icon(
                  avaiableReminder.iconData,
                  color: avaiableReminder.color
                ),
                Text(' ${avaiableReminder.title}'),
                Text(' ($amount)')
              ],
            )
          )
        )
      ),
    );
  }
}
