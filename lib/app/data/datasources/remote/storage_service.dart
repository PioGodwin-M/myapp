import 'dart:io';
import 'dart:developer' as developer;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference reference = _storage.ref().child('products/$fileName');
      final UploadTask uploadTask = reference.putFile(image);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e, s) {
      developer.log(
        'Error uploading image',
        name: 'com.example.myapp.storage',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
