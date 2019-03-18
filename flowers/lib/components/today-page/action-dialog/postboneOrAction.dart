import 'package:flutter/material.dart';

import '../../../flower.dart';
import '../../../constants/colors.dart';
import '../../../constants/enums.dart';
import '../../../utils/firebase-redux.dart';
import '../../../utils/soilMoisture.dart';
import '../../gradientMaterialButton.dart';

class PostponeOrActionButtons extends StatefulWidget {
  final bool isLoading;
  final Function onActionPress;
  final Function onPostponePress;

  final String postponeSubtitle;
  final String postponeTitle;
  final String actionSubtitle;
  final String actionTitle;

  PostponeOrActionButtons({
    this.isLoading,
    this.onActionPress,
    this.onPostponePress,
    this.postponeSubtitle,
    this.postponeTitle,
    this.actionSubtitle,
    this.actionTitle,
  });

  @override
    State<StatefulWidget> createState() {
      return PostponeOrActionButtonsState();
    }
}

enum ButtonAction {
  Action,
  Postpone
}

class PostponeOrActionButtonsState extends State<PostponeOrActionButtons> {
  ButtonAction buttonAction;

  Widget _getSubtitleWidget(String subtitle) {
    if (subtitle == null) {
      return Container();
    }

    return Text(subtitle,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Colors.white
      )
    );
  }


  Widget getPostponeButtonChild() {
    if (buttonAction != ButtonAction.Postpone) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.postponeTitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
          ),
          _getSubtitleWidget(widget.postponeSubtitle)
        ],
      );
    }

    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }

  Widget getActionButtonChild() {
    if (buttonAction != ButtonAction.Action) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.actionTitle,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white
            ),
          ),
          _getSubtitleWidget(widget.actionSubtitle)
        ],
      );
    }
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 48),
      height: 80,
      color: Colors.green,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GradientButton(
            height: 80,
            width: 120,
            gradient: buttonAction == ButtonAction.Action ? GreyGradient : YellowGradient,
            onPressed: widget.isLoading ? null : () {
              setState(() {
                buttonAction = ButtonAction.Postpone;
              });
              widget.onPostponePress();
            },
            child: getPostponeButtonChild()
          ),
          Expanded(
            child: GradientButton(
              height: 80,
              gradient: buttonAction == ButtonAction.Postpone ? GreyGradient : BlueGradient,
              onPressed: widget.isLoading ? null : () {
                setState(() {
                  buttonAction = ButtonAction.Action;
                });
                widget.onActionPress();
              },
              child: getActionButtonChild(),
            ),
          ),
        ]
      ),
    );
  }
}
