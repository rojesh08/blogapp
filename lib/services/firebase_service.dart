import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final postRef = FirebaseDatabase.instance.reference().child('Posts');

  Future<String?> uploadImage(File? image) async {
    try {
      if (image != null) {
        int date = DateTime.now().millisecondsSinceEpoch;
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/blogapp$date');
        firebase_storage.UploadTask uploadTask = ref.putFile(image.absolute);
        await Future.value(uploadTask);
        var newUrl = await ref.getDownloadURL();
        return newUrl.toString();
      }
      return null;
    } catch (error) {
      print("Error uploading image: $error");
      return null;
    }
  }

  Future<void> uploadBlog({
    required String title,
    required String description,
    File? image,
  }) async {
    try {
      String? imageUrl = await uploadImage(image);

      if (imageUrl != null) {
        int date = DateTime.now().millisecondsSinceEpoch;
        final User? user = _auth.currentUser;
        await postRef.child('Blog List').child(date.toString()).set({
          'pId': date.toString(),
          'pImage': imageUrl,
          'pTime': date.toString(),
          'pTitle': title,
          'pDescription': description,
          'uEmail': user!.email.toString(),
          'uId': user.uid.toString(),
        });


      } else {
        throw Exception('Image upload failed');
      }
    } catch (error) {
      print("Error uploading blog: $error");
      throw Exception('Could not upload blog');
    }
  }
}
