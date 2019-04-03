import 'package:flutter/material.dart';

import '../multible-dialog/multibleDialog.dart';

class AllButton extends StatelessWidget {
  final int amount;
  final Function onActionPress;
  final Function(int) onPostponePress;

  AllButton({
    this.amount,
    this.onActionPress,
    this.onPostponePress,
  });

  void _onTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => MultibleDialog(
        actionTitle: 'run all',
        bodyText: 'Run ALL reminders on all\nselected plants ($amount)',
        onActionPress: () {
          onActionPress();
        },
        onPostponePress: (int days) {
          onPostponePress(days);
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
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
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          onTap: () {
            _onTap(context);

          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: <Widget>[
                Text('All'),
              ],
            )
          )
        )
      ),
    );
  }
}
