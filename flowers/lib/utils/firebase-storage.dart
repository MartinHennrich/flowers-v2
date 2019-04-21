import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://flowers-98123.appspot.com');
  StorageReference userRef;

  Storage(String userId) {
    userRef = storage.ref().child(userId);
  }

  Future<Map<String, String>> uploadImageFile(File file) async {
    String id = Uuid().v4();

    StorageReference fileRef = userRef.child('images/$id.png');
    StorageUploadTask uploadTask = fileRef.putFile(file);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    String url = await snapshot.ref.getDownloadURL();

    return {
      'url': url,
      'id': id
    };
  }

  removeImage(String id) async {
    return userRef.child('images/$id.png').delete();
  }
}

