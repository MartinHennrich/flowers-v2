import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

String generateUserId() {
  Uuid uuid = new Uuid();
  return uuid.v4();
}

class Database {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  DatabaseReference userDatabaseReference;
  String userId;

  Database() {
    getIntialData();
  }

  Future<DataSnapshot> _fetchData() {
    return userDatabaseReference.once();
  }

  void _setUserRef() {
    userDatabaseReference = FirebaseDatabase
      .instance
      .reference()
      .child(userId);
  }

  Future<DataSnapshot> _createNewUser(SharedPreferences prefs) async {
    userId = generateUserId();
    await prefs.setString('my_userId_2', userId);

    await databaseReference.child(userId).set({
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = (prefs.getString('my_userId_2') ?? null);

    if (userId == null) {
      return await _createNewUser(prefs);
    }

    _setUserRef();
    return await _fetchData();
  }
}

