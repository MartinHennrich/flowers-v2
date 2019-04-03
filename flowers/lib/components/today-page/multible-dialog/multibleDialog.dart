import 'package:flutter/material.dart';

import '../../../flower.dart';
import '../../create-flower/intervall.dart';
import '../action-dialog/postboneOrAction.dart';

class MultibleDialog extends StatefulWidget {
  final int amount;
  final String actionTitle;
  final String bodyText;
  final Function onActionPress;
  final Function(int days) onPostponePress;

  MultibleDialog({
    this.amount,
    this.actionTitle,
    this.bodyText,
    this.onActionPress,
    this.onPostponePress,
  });

  @override
  MultibleDialogState createState() {
    return MultibleDialogState();
  }
}

class MultibleDialogState extends State<MultibleDialog> {
  bool _isLoading = false;
  int postponeDays = 1;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      contentPadding: EdgeInsets.all(0),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: 290,
              margin: EdgeInsets.fromLTRB(16, 16, 0, 8),
              child: Text('Quick action',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, size: 28, color: Colors.grey)
              ),
            ),
          ],
        ),

        widget.bodyText != null
          ? Padding(
              padding: EdgeInsets.fromLTRB(8, 24, 8, 0),
              child: Center(
                child: Text(
                  widget.bodyText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )
              )
            )
          : Container(),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: IntervallPure(
            color: Colors.black,
            type: 'postpone',
            value: postponeDays,
            onIncrease: (v) {
              setState(() {
                postponeDays = v;
              });
            },
            onDecrease:  (v) {
              setState(() {
                postponeDays = v;
              });
            },
          )
        ),
        PostponeOrActionButtons(
          isLoading: _isLoading,
          onActionPress: () {
            setState(() {
              _isLoading = true;
            });
            widget.onActionPress();
          },
          onPostponePress: () {
            setState(() {
              _isLoading = true;
            });
            widget.onPostponePress(postponeDays);
          },
          postponeSubtitle: widget.amount != null ? '${widget.amount} reminders' : null,
          postponeTitle: 'POSTPONE',
          actionSubtitle: widget.amount != null ? '${widget.amount} plants' : null,
          actionTitle: '${widget.actionTitle.toUpperCase()}',
        )
      ],
    );
  }
}
