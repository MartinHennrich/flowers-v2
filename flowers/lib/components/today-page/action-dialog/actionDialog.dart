import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../flower.dart';
import '../../flower-details/labels-list/labelsList.dart';

class ActionDialog extends StatelessWidget {
  final Flower flower;
  final Widget actionButtons;
  final Widget customControls;

  ActionDialog({
    this.flower,
    this.actionButtons,
    this.customControls
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      contentPadding: EdgeInsets.all(0),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(flower.imageUrl),
                    fit: BoxFit.cover,
                  ),
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

        Center(
          child: Container(
            width: 290, // dialog min with
            child: Text(flower.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28
              )
            ),
          )
        ),
        Container(
          width: 10,
          padding: EdgeInsets.only(top: flower.labels.length > 0 ? 16 : 0),
          alignment: Alignment(0, 0),
          child: LabelsList(
            labels: flower.labels
          )
        ),
        customControls,
        actionButtons
      ],
    );
  }
}
