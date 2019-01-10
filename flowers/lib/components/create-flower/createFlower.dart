import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../constants/colors.dart';
import '../../utils/firebase.dart';
import '../../flower.dart';
import '../../store.dart';
import '../../actions/actions.dart';
import '../../utils/notifications.dart';

import './getImage.dart';
import './lastWaterTime.dart';
import './waterIntervall.dart';

class CreateFlower extends StatefulWidget {
  @override
  _CreateFlowerState createState() => _CreateFlowerState();
}

class FlowerFormData {
  File image;
  String flowerName = '';
  DateTime lastWaterTime = DateTime.now();
  int waterIntervall = 5;
}

class _CreateFlowerState extends State<CreateFlower> {
  bool _isCreatingFlower = false;
  final _formKey = GlobalKey<FormState>();
  FlowerFormData flowerFormData = FlowerFormData();

  Future<void> _onCreateFlower() async {
    File image = flowerFormData.image;
    var dir = Directory.systemTemp;
    var targetPath = dir.absolute.path + "/temp.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      targetPath,
      quality: 50,
      rotate: 90,
      minHeight: 400,
      minWidth: 400
    );

    var response = await database.createFlower(
      result,
      flowerFormData.flowerName,
      flowerFormData.lastWaterTime,
      flowerFormData.lastWaterTime,
      flowerFormData.waterIntervall,
    );

    DateTime nextWaterTime = flowerFormData
      .lastWaterTime
      .add(Duration(days: flowerFormData.waterIntervall));

    Flower flower = Flower(
      key: response['key'],
      name: flowerFormData.flowerName,
      imageUrl:  response['imageUrl'],
      lastTimeWatered: flowerFormData.lastWaterTime,
      nextWaterTime: nextWaterTime,
      waterInterval: flowerFormData.waterIntervall
    );

    AppStore.dispatch(AddFlowerAction(flower));
    AppStore.dispatch(CreatingFlower.Available);

    scheduleNotification(
      flower.key,
      flower.name,
      flower.nextWaterTime
    );

    dir.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('ADD FLOWER'),
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

                  TextFormField(
                    onSaved: (form) {
                      flowerFormData.flowerName = form;
                    },
                    decoration: InputDecoration(
                      hintText: 'Batman?',
                      labelText: 'Name',
                    ),
                    validator: (String value) {
                      if (value.length < 2) {
                        return 'Minimun of 2 chars';
                      }

                      if (value.length > 12) {
                        return 'Max of 12 chars';
                      }

                      return null;
                    },
                  ),

                  LastWaterTime(
                    onSave: (DateTime lastWaterTime) {
                      flowerFormData.lastWaterTime = lastWaterTime;
                    },
                  ),

                  WaterIntervall(
                    onSave: (int waterIntervall) {
                      flowerFormData.waterIntervall = waterIntervall;
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 78),
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
                          Text('Add flower',
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
