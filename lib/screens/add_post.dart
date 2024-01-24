

import 'dart:io';

import 'package:blogapp/components/round_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _image;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  String title = "", description = "";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Upload Blogs'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height*.2,
                  width: MediaQuery.of(context).size.height* 1,
                  child: _image !=null ? ClipRect(
                    child: Image.file(
                      _image!.absolute,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  ):Container(
                    decoration: BoxDecoration(
                      color:Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                    height: 100,
                    width: 100,
                    child: const Icon(
                      Icons.camera_alt,
                      color:Colors.deepOrange,
                    ),

                  )
                ),
              ),
              SizedBox(height: 30,),
              Form(
                  key:_formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      decoration:  const InputDecoration(
                          labelText: 'Title',
                        hintText: 'Enter the title of your blog',
                          border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)
                      ),
                      onChanged: (String value){
                        title = value;
                      },
                      validator:(value){
                        return value!.isEmpty ? 'Enter Title' : null;
                      },
                    ),
                     SizedBox(height: 20,),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 10,
                      decoration:  const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter the description of your blog',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)
                      ),
                      onChanged: (String value){
                        description = value;
                      },
                      validator:(value){
                        return value!.isEmpty ? 'Enter Description' : null;
                      },
                    ),
                    SizedBox(height: 30,),
                    RoundButton(title: 'Upload', onPress: (){
                      if(_formkey.currentState!.validate());
                    })

                  ],
                )
              )
            ],

          ),
        ),
      )
    );
  }
}
