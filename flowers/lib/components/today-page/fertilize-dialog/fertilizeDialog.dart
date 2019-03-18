import 'package:flutter/material.dart';

import '../../../flower.dart';
import '../action-dialog/postboneOrAction.dart';
import '../action-dialog/actionDialog.dart';
import '../../../utils/firebase-redux.dart';
import '../../create-flower/intervall.dart';

class FertilizeDialog extends StatefulWidget {
  final Flower flower;

  FertilizeDialog({
    this.flower
  });

  @override
  FertilizeDialogState createState() {
    return FertilizeDialogState();
  }
}

class FertilizeDialogState extends State<FertilizeDialog> {
  bool _isLoading = false;
  int postponeDays = 1;

  @override
  Widget build(BuildContext context) {
    return ActionDialog(
      flower: widget.flower,
      customControls: IntervallPure(
        value: postponeDays,
        type: 'postpone',
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

          fertilizeFlower(widget.flower)
            .then((_) {
              Navigator.of(context).pop();
            });
        },
        onPostponePress: () {
          setState(() {
            _isLoading = true;
          });

          postponeFertilize(widget.flower, postponeDays)
            .then((_) {
              Navigator.of(context).pop();
            });
        },
        postponeSubtitle: '$postponeDays',
        postponeTitle: 'POSTPONE',
        actionSubtitle: null,
        actionTitle: 'FERTILIZE',
      )
    );
  }
}
