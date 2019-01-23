import 'package:flutter/material.dart';

import '../../utils/firebase.dart';
import '../../actions/actions.dart';
import '../../flower.dart';
import '../../store.dart';
import '../../constants/colors.dart';


class DeleteDialog extends StatelessWidget {
  final Flower flower;

  DeleteDialog({
    this.flower
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      title: Text('Do you want to delete ${flower.name}?',),
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('NO :)'),
            ),
            FlatButton(
              color: RedMain,
              onPressed: () {
                database.deleteFlower(flower.key);
                Navigator.pop(context);
                AppStore.dispatch(DeleteFlowerAction(flower));
                Navigator.of(context).pop();
              },
              child: Text(
                'YES DELETE',
                style: TextStyle(
                  color: Colors.white
                )
              ),
            )
          ],
        )
      ],
    );
  }
}
