import 'package:flutter/material.dart';

import '../../../flower.dart';
import '../../../utils/firebase-redux.dart';
import '../../create-flower/intervall.dart';
import '../action-dialog/actionDialog.dart';
import '../action-dialog/postboneOrAction.dart';

class RotateDialog extends StatefulWidget {
  final Flower flower;

  RotateDialog({
    this.flower
  });

  @override
  RotateDialogState createState() {
    return RotateDialogState();
  }
}

class RotateDialogState extends State<RotateDialog> {
  bool _isLoading = false;
  int postponeDays = 1;

  @override
  Widget build(BuildContext context) {
    return ActionDialog(
      flower: widget.flower,
      customControls: IntervallPure(
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
      ),
      actionButtons: PostponeOrActionButtons(
        isLoading: _isLoading,
        onActionPress: () {
          setState(() {
            _isLoading = true;
          });

          rotateFlower(widget.flower)
            .then((_) {
              Navigator.of(context).pop();
            });
        },
        onPostponePress: () {
          setState(() {
            _isLoading = true;
          });

          postponeRotate(widget.flower, postponeDays)
            .then((_) {
              Navigator.of(context).pop();
            });
        },
        postponeSubtitle: '$postponeDays',
        postponeTitle: 'POSTPONE',
        actionSubtitle: null,
        actionTitle: 'ROTATE',
      )
    );
  }
}
