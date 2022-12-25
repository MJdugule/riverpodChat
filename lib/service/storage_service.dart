import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider(
    (ref) => StorageService(firebaseStorage: FirebaseStorage.instance));

class StorageService {
  final FirebaseStorage firebaseStorage;
  StorageService({
    required this.firebaseStorage,
  });

  Future<String> sendFile(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
