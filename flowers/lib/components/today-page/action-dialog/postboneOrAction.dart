import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../gradientMaterialButton.dart';

class PostponeOrActionButtons extends StatefulWidget {
  final bool isLoading;
  final Function onActionPress;
  final Function onPostponePress;

  final String postponeSubtitle;
  final String postponeTitle;
  final String actionSubtitle;
  final String actionTitle;
  final double marginTop;

  PostponeOrActionButtons({
    this.isLoading,
    this.onActionPress,
    this.onPostponePress,
    this.postponeSubtitle,
    this.postponeTitle,
    this.actionSubtitle,
    this.actionTitle,
    this.marginTop = 48,
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
    String days = '';
    try {
      days = int.parse(subtitle) == 1  ? 'day' : 'days';
    } catch (e) {
      // swallow
    }

    return Text('$subtitle $days',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12,
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
              fontSize: 20,
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
      margin: EdgeInsets.only(top: widget.marginTop),
      height: 90,
      /* color: Colors.grey.withAlpha(30), */
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: GradientButton(
              height: 60,
              width: 120,
              buttonRadius: BorderRadius.all(Radius.circular(8)),
              gradient: buttonAction == ButtonAction.Action ? GreyGradient : YellowGradient,
              onPressed: widget.isLoading ? null : () {
                setState(() {
                  buttonAction = ButtonAction.Postpone;
                });
                widget.onPostponePress();
              },
              child: getPostponeButtonChild()
            )),
            Container(
              child: GradientButton(
                height: 60,
                width: 160,
                buttonRadius: BorderRadius.all(Radius.circular(8)),
                gradient: buttonAction == ButtonAction.Postpone ? GreyGradient : BlueGradient,
                onPressed: widget.isLoading ? null : () {
                  setState(() {
                    buttonAction = ButtonAction.Action;
                  });
                  widget.onActionPress();
                },
                child: getActionButtonChild(),
          )),
        ]
      ),
    );
  }
}
