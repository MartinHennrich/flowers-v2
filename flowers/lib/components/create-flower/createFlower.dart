import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../../actions/actions.dart';
import '../../constants/colors.dart';
import '../../flower.dart';
import '../../reminders.dart';
import '../../store.dart';
import '../../utils/firebase.dart';
import '../../utils/image.dart';
import '../../utils/notifications.dart';
import './addReminders.dart';
import './getImage.dart';
import './name.dart';
import '../../presentation/customScrollColor.dart';

class CreateFlower extends StatefulWidget {
  @override
  _CreateFlowerState createState() => _CreateFlowerState();
}

class FlowerFormData {
  File image;
  String flowerName = '';
  ImageSourceType imageSourceType = ImageSourceType.Camera;
  Reminders reminders = Reminders();
}

class _CreateFlowerState extends State<CreateFlower> {
  bool _isCreatingFlower = false;
  final _formKey = GlobalKey<FormState>();
  FlowerFormData flowerFormData = FlowerFormData();

  Future<void> _onCreateFlower() async {
    File image = flowerFormData.image;
    var result = await compressImageFile(image, rotate: flowerFormData.imageSourceType == ImageSourceType.Camera);

    Flower _flower = Flower(
      key: '',
      name: flowerFormData.flowerName,
      imageUrl: '',
      reminders: flowerFormData.reminders
    );

    var response = await database.createFlower(
      result,
      _flower
    );

    Flower flower = Flower(
      key: response['key'],
      name: flowerFormData.flowerName,
      imageUrl:  response['imageUrl'],
      imageId: response['imageId'],
      reminders: flowerFormData.reminders
    );

    AppStore.dispatch(AddFlowerAction(flower));
    AppStore.dispatch(CreatingFlower.Available);

    scheduleNotificationsForReminders(flower.name, flower.reminders);

    await result.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('ADD PLANT'),
      ),
      body: CustomScrollColor(
        child: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GetImage(
                    onSave: (File image, imageSourceType) {
                      flowerFormData.image = image;
                      flowerFormData.imageSourceType = imageSourceType;
                    },
                  ),

                  Name(
                    onSave: (name) {
                      flowerFormData.flowerName = name;
                    },
                  ),

                  AddReminders(
                    onSave: (Reminders reminders) {
                      flowerFormData.reminders = reminders;
                    }
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 24, 0, 24),
                    child: GradientButton(
                      gradient: BlueGradient,
                      increaseHeightBy: 30,
                      increaseWidthBy: 300,
                      shapeRadius: BorderRadius.horizontal(left: Radius.circular(0)),
                      callback: _isCreatingFlower ? null : () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          setState(() {
                            _isCreatingFlower = true;
                          });
                          AppStore.dispatch(CreatingFlower.Creating);
                          Navigator.pop(context);
                          await _onCreateFlower();
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Add plant',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              )
            ),
          ),
        ]
      )
    ));
  }
}
