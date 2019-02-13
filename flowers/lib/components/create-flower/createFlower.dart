import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../../constants/colors.dart';
import '../../utils/firebase.dart';
import '../../flower.dart';
import '../../store.dart';
import '../../actions/actions.dart';
import '../../utils/notifications.dart';
import '../../utils/image.dart';

import './getImage.dart';
import './lastWaterTime.dart';
import './intervall.dart';
import './pickTime.dart';
import './name.dart';

class CreateFlower extends StatefulWidget {
  @override
  _CreateFlowerState createState() => _CreateFlowerState();
}

class FlowerFormData {
  File image;
  String flowerName = '';
  DateTime lastWaterTime = DateTime.now();
  DateTime notificationTime = DateTime(2019, 1, 1, 8, 0);
  int waterIntervall = 5;
}

class _CreateFlowerState extends State<CreateFlower> {
  bool _isCreatingFlower = false;
  final _formKey = GlobalKey<FormState>();
  FlowerFormData flowerFormData = FlowerFormData();

  Future<void> _onCreateFlower() async {
    File image = flowerFormData.image;
    var result = await compressImageFile(image);

    DateTime nextWaterTime = flowerFormData
      .lastWaterTime
      .add(Duration(days: flowerFormData.waterIntervall));

    Flower _flower = Flower(
      key: '',
      name: flowerFormData.flowerName,
      imageUrl: '',
      reminders: Reminders(
        water: Reminder(
          interval: flowerFormData.waterIntervall,
          lastTime: flowerFormData.lastWaterTime,
          nextTime: nextWaterTime,
          timeOfDayForNotification: flowerFormData.notificationTime,
          key: 'water'
        )
      ),
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
      reminders: Reminders(
        water: Reminder(
          interval: flowerFormData.waterIntervall,
          lastTime: flowerFormData.lastWaterTime,
          nextTime: nextWaterTime,
          timeOfDayForNotification: flowerFormData.notificationTime,
          key: 'water',
          type: ReminderType.Water
        )
      ),
    );

    AppStore.dispatch(AddFlowerAction(flower));
    AppStore.dispatch(CreatingFlower.Available);

    scheduleNotification(
      flower.key,
      flower.name,
      flower.reminders.water.nextTime,
      flower.reminders.water.timeOfDayForNotification
    );

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
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GetImage(
                    onSave: (File image) {
                      flowerFormData.image = image;
                    },
                  ),

                  Name(
                    onSave: (name) {
                      flowerFormData.flowerName = name;
                    },
                  ),

                  LastWaterTime(
                    onSave: (DateTime lastWaterTime) {
                      flowerFormData.lastWaterTime = lastWaterTime;
                    },
                  ),

                  Intervall(
                    onSave: (int waterIntervall) {
                      flowerFormData.waterIntervall = waterIntervall;
                    },
                    type: 'Water',
                  ),

                  PickTimeForm(
                    onSave: (DateTime time) {
                      flowerFormData.notificationTime = time;
                    },
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
    );
  }
}
