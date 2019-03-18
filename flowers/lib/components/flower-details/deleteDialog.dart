import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class DeleteDialog extends StatelessWidget {
  final Function(BuildContext context) onRemove;
  final String name;

  DeleteDialog({
    this.onRemove,
    this.name
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      title: Text('Do you want to delete ${name.trim()}?',),
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('NO'),
            ),
            FlatButton(
              color: RedMain,
              onPressed: () {
                onRemove(context);
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
