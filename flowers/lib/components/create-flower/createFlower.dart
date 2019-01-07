import 'package:flutter/material.dart';
import 'dart:io';

import '../../constants/colors.dart';
import '../../utils/firebase.dart';
import '../../flower.dart';
import '../../store.dart';
import '../../actions/actions.dart';

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
    var response = await database.createFlower(
      flowerFormData.image,
      flowerFormData.flowerName,
      flowerFormData.lastWaterTime,
      flowerFormData.lastWaterTime,
      flowerFormData.waterIntervall,
    );

    DateTime today = DateTime.now();
    DateTime nextWaterTime = flowerFormData
      .lastWaterTime
      .add(Duration(days: flowerFormData.waterIntervall));

    if (nextWaterTime.day <= today.day && nextWaterTime.month <= today.month) {
      nextWaterTime = today;
    }

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
                      labelText: 'Flower name',
                    ),
                    validator: (String value) {
                      return value.length < 2 ? 'Minimun of 2 chars' : null;
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
                    margin: EdgeInsets.only(top: 48),
                    alignment: Alignment(0, 0),
                    child: MaterialButton(
                      height: 60,
                      minWidth: 200,
                      color: MainColor,
                      disabledColor: Colors.grey,
                      onPressed: _isCreatingFlower ? null : () async {
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
