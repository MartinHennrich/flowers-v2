import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Storage {
  final String storageBucket = 'gs://flowers-98123.appspot.com';
  final FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://flutter-firebase-plugins.appspot.com');
  StorageReference userRef;

  Storage(String userId) {
    userRef = storage.ref().child(userId);
  }

  uploadImageFile(File file) async {
    String id = Uuid().v4();

    StorageReference fileRef = userRef.child('images/$id.png');
    StorageUploadTask uploadTask = fileRef.putFile(file);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    return await snapshot.ref.getDownloadURL();
  }
}

