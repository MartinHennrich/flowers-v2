import 'package:flutter/material.dart';

import '../../presentation/customScrollColor.dart';
import '../../constants/colors.dart';
import './rating.dart';

class WhatsNewDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      contentPadding: EdgeInsets.all(20),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: 300,
                height: 40,
                child: Text('New Update 🤩', style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                padding: EdgeInsets.all(0),
                alignment: Alignment(1, -1),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close, size: 28, color: Colors.grey,

                )
              ),
            ),
          ],
        ),
        Container(
          width: 300,
          height: 420,
          child: CustomScrollColor(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: BlueMain,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child:Text('Fixes', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        ),
                      )
                    ),
                    Text('- Notifications should now be more reliable 🔔', style: TextStyle(fontSize: 16)),
                    Text('- Editing plant image now works 📸', style: TextStyle(fontSize: 16)),
                    Text('- Other minor fixes', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: BlueSecond,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child:Text('Features', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text('Labels', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                        ),
                      )
                    ),
                    Text('You can now add labels to your plants ❤️ Add quick information like location, water amount, plant type and more 👐 Go to plant details and then press the label button to add or remove labels! You can even sort on labels in the Garden view and see your labels when preforming actions.', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              Rating(),
            ]
          )
        ))
      ],
    );
  }
}
