import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}

