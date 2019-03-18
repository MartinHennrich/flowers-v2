import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../flower.dart';

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
            child: Text(flower.name,
              style: TextStyle(
                fontSize: 28
              )
            ),
          )
        ),
        customControls,
        actionButtons
      ],
    );
  }
}
