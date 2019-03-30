import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../flower.dart';
import '../reminders.dart';
import '../utils/waterAmount.dart';
import '../utils/soilMoisture.dart';
import './firebase-storage.dart';

class Database {
  Storage _storage;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  DatabaseReference userDatabaseReference;
  FirebaseUser currentUser;

  Future<FirebaseUser> _signInAnonymous() async {
    FirebaseUser user = await firebaseAuth.signInAnonymously();
    return user;
  }

  Future<DataSnapshot> _fetchData() {
    return userDatabaseReference.once();
  }

  void _setUserRef() {
    userDatabaseReference = FirebaseDatabase
      .instance
      .reference()
      .child('users')
      .child(currentUser.uid);
  }

  Future<DataSnapshot> _createInitialData() async {
    await databaseReference
      .child('users')
      .child(currentUser.uid).set({
        'flowers': {
          '__none__': {
            'name': '',
            'image': '',
          }
        },
        'created_at': DateTime.now().toIso8601String()
      });
    _setUserRef();
    return await _fetchData();
  }

  void dispose() {}

  Future<DataSnapshot> getIntialData() async {
    currentUser = await firebaseAuth.currentUser();

    if (currentUser == null) {
      currentUser = await _signInAnonymous();
      return await _createInitialData();
    }
    _setUserRef();
    return await _fetchData();
  }

  Future<void> addWaterTime(String key, WaterTime waterTime) async {
    return databaseReference
      .child('waterTimes')
      .child(currentUser.uid)
      .child(key)
      .push().set({
        'time': waterTime.wateredTime.toIso8601String(),
        'amount': waterAmountToInt(waterTime.waterAmount),
        'soil': soilMoistureToInt(waterTime.soilMoisture)
      });
  }

  Future<void> waterFlower(Flower flower, WaterTime waterTime) async {
    await addWaterTime(flower.key, waterTime);

    return userDatabaseReference
      .child('flowers')
      .child(flower.key)
      .child('reminders')
      .update(flower.reminders.toFirebaseObject());
  }

  Future<void> postponeWatering(Flower flower) async {
    return userDatabaseReference
      .child('flowers')
      .child(flower.key)
      .child('reminders')
      .child('water')
      .update({
        'nextTime': flower.reminders.water.nextTime.toIso8601String(),
      });
  }

  Future<void> updateAllReminders(Flower flower) async {
    return userDatabaseReference
      .child('flowers')
      .child(flower.key)
      .child('reminders')
      .update(flower.reminders.toFirebaseObject());
  }

  Future<void> postpone(Flower flower, Reminder reminder) async {
    return userDatabaseReference
      .child('flowers')
      .child(flower.key)
      .child('reminders')
      .child(reminder.key)
      .update({
        'nextTime': reminder.nextTime.toIso8601String(),
      });
  }

  _initialStorage() {
    _storage = Storage(currentUser.uid);
  }

  Future<Map<String, String>> _uploadImageFile(File file) async {
    if (_storage == null) {
      _initialStorage();
    }

    return await _storage.uploadImageFile(file);
  }

  Future<dynamic> updateflower(Flower flower, {File file}) async {
    var flowerRef = userDatabaseReference
      .child('flowers')
      .child(flower.key);

    if (file != null) {
      await _storage.removeImage(flower.imageId);
      Map<String, String> map = await _uploadImageFile(file);
      String fileUrl = map['url'];
      String fileId = map['id'];

      await flowerRef
        .update({
          'name': flower.name,
          'image': fileUrl,
          'imageId': fileId,
          'reminders': flower.reminders.toFirebaseObject(),
        });

      return {
        'imageUrl': fileUrl,
        'imageId': fileId,
      };
    }

    userDatabaseReference
      .child('flowers')
      .child(flower.key)
      .update({
        'name': flower.name,
        'reminders': flower.reminders.toFirebaseObject(),
      });

    return {
      'imageUrl': flower.imageUrl,
      'imageId': flower.imageId,
    };
  }

  Future<dynamic> createFlower(File file, Flower flower) async {
    Map<String, String> map = await _uploadImageFile(file);
    String fileUrl = map['url'];
    String fileId = map['id'];

    DatabaseReference flowerPush = userDatabaseReference
      .child('flowers')
      .push();

    await flowerPush.set({
      'name': flower.name,
      'image': fileUrl,
      'imageId': fileId,
      'reminders': flower.reminders.toFirebaseObject()
    });

    return {
      'imageUrl': fileUrl,
      'imageId': fileId,
      'key': flowerPush.key
    };
  }

  Future<DataSnapshot> getFlowerWaterTimes(String key) async {
    return await FirebaseDatabase
      .instance
      .reference()
      .child('waterTimes')
      .child(currentUser.uid)
      .child(key)
      .once();
  }

  Future<void> deleteFlower(String key) async {
    return userDatabaseReference
      .child('flowers')
      .child(key)
      .remove();
  }
}

Database database = Database();
