import 'dart:io';
import 'package:blogapp/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postRef = FirebaseDatabase.instance.reference().child('Posts');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  String title = "", description = "";

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future<String?> uploadImage() async {
    try {
      if (_image != null) {
        int date = DateTime.now().millisecondsSinceEpoch;
        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/blogapp$date');
        UploadTask uploadTask = ref.putFile(_image!.absolute);
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

  void uploadBlog() async {
    if (_formkey.currentState!.validate()) {
      try {
        String? imageUrl = await uploadImage();

        if (imageUrl != null) {
          int date = DateTime.now().millisecondsSinceEpoch;
          final User? user = _auth.currentUser;
          postRef.child('Blog List').child(date.toString()).set({
            'pId': date.toString(),
            'pImage': imageUrl,
            'pTime': date.toString(),
            'pTitle': titleController.text.toString(),
            'pDescription': descriptionController.text.toString(),
            'uEmail': user!.email.toString(),
            'uId': user.uid.toString(),
          }).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Blog Uploaded'),
                duration: Duration(seconds: 4),
                backgroundColor: Colors.deepOrange,
              ),
            );
          }).onError((error, stackTrace) {
            print(error.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not upload the file: $error'),
                duration: Duration(seconds: 4),
                backgroundColor: Colors.deepOrange,
              ),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image upload failed'),
              duration: Duration(seconds: 4),
              backgroundColor: Colors.deepOrange,
            ),
          );
        }
      } catch (error) {
        print(error.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not upload the file: $error'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }

  void dialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImageCamera();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getImageGallery();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Upload Blogs'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.orange[100],
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  dialog(context);
                },
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.height * 1,
                    child: _image != null
                        ? ClipRect(
                      child: Image.file(
                        _image!.absolute,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      height: 100,
                      width: 100,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter the title of your blog',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                      onChanged: (String value) {
                        title = value;
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'Enter Title' : null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter the description of your blog',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                      onChanged: (String value) {
                        description = value;
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'Enter Description' : null;
                      },
                    ),
                    SizedBox(height: 30,),
                    RoundButton(
                      title: 'Upload',
                      onPress: () async {
                        uploadBlog();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
