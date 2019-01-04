import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../flower.dart';
import '../utils/firebase-redux.dart';

class Database {
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
      .child(currentUser.uid);
  }

  Future<DataSnapshot> _createInitialData() async {
    await databaseReference.child(currentUser.uid).set({
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

  Future<void> waterFlower(Flower flower, WaterTime waterTime) async {
    userDatabaseReference.child('flowers').child(flower.key)
      .child('waterTimes')
      .push().set({
        'time': waterTime.wateredTime.toIso8601String(),
        'amount': waterAmountToInt(waterTime.waterAmount),
        'soil': soilMoistureToInt(waterTime.soilMoisture)
      });

    return userDatabaseReference.child('flowers').child(flower.key)
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
}

Database database = Database();
