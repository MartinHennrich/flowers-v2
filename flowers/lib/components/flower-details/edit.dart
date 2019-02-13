import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../utils/firebase.dart';
import '../../flower.dart';
import '../../store.dart';
import '../../actions/actions.dart';
import '../../utils/notifications.dart';
import '../../utils/image.dart';

import '../create-flower/getImage.dart';
import '../create-flower/intervall.dart';
import '../create-flower/pickTime.dart';
import '../create-flower/name.dart';

class EditFlower extends StatefulWidget {
  final Flower flower;

  EditFlower({
    this.flower
  });

  @override
  _EditFlowerState createState() => _EditFlowerState();
}

class FlowerFormData {
  File image;
  String flowerName = '';
}

class _EditFlowerState extends State<EditFlower> {
  bool _isCreatingFlower = false;
  final _formKey = GlobalKey<FormState>();
  FlowerFormData flowerFormData = FlowerFormData();

  Future<void> _onEditFlower() async {
    Flower flower = widget.flower;
    if (flowerFormData.flowerName.length >= 3) {
      flower.name = flowerFormData.flowerName;
    }

    File image;

    if (flowerFormData.image != null) {
      File imageFile = flowerFormData.image;
      image = await compressImageFile(imageFile);
    }

    try {
      Map<String, String> result = await database.updateflower(flower, file: image);
      if (image != null) {
        await image.delete();
      }
      flower.imageId = result['imageId'];
      flower.imageUrl = result['imageUrl'];

      AppStore.dispatch(UpdateFlowerAction(flower));
      Navigator.pop(context);

      rescheduleNotification(
        flower.key,
        flower.name,
        flower.reminders.water.nextTime,
        flower.reminders.water.timeOfDayForNotification
      );
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('EDIT ${widget.flower.name.toUpperCase()}'),
        actions: <Widget>[
          FlatButton(
            onPressed: _isCreatingFlower ? null : () async {
              _formKey.currentState.save();
              _onEditFlower();
            },
            child: Text('SAVE'),
          )
        ],
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
                    prefilled: widget.flower.name,
                    onSave: (name) {
                      flowerFormData.flowerName = name;
                    },
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
