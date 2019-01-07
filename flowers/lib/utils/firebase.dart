import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../flower.dart';
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
            'lastTimeWatered': '',
            'nextWaterTime': ''
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
      .update({
        'nextWaterTime': flower.nextWaterTime.toIso8601String(),
        'lastTimeWatered': flower.lastTimeWatered.toIso8601String()
      });
  }

  Future<void> postponeWatering(Flower flower) async {
    return userDatabaseReference.child('flowers').child(flower.key)
      .update({
        'nextWaterTime': flower.nextWaterTime.toIso8601String(),
      });
  }

  _initialStorage() {
    _storage = Storage(currentUser.uid);
  }

  Future<String> _uploadImageFile(File file) async {
    if (_storage == null) {
      _initialStorage();
    }

    return await _storage.uploadImageFile(file);
  }

  Future<dynamic> createFlower(File file, String name, DateTime lastWaterTime, DateTime nextWaterTime, int intervall) async {
    String fileUrl = await _uploadImageFile(file);

    DatabaseReference flowerPush = userDatabaseReference
      .child('flowers')
      .push();

     await flowerPush.set({
        'name': name,
        'image': fileUrl,
        'lastTimeWatered': lastWaterTime.toIso8601String(),
        'nextWaterTime': nextWaterTime.toIso8601String(),
        'waterInterval': intervall,
      });

    return {
      'imageUrl': fileUrl,
      'key': flowerPush.key
    };
  }
}

Database database = Database();
