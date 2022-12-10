import 'dart:developer';
import 'dart:io';

import 'package:attendance/models/usermodel.dart';
import 'package:attendance/screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class UserDetails extends StatefulWidget {

  final UserModel userModel;
  final User firebaseuser;
  UserDetails({required this.userModel,required this.firebaseuser});
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  var fullnameController=TextEditingController();
  File? pickedImage;

  void pickImageOptions(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
       title: Text('Select Image From'),
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           ListTile(onTap: (){
             pickImage(ImageSource.gallery);
          },
             leading: Icon(Icons.image),
             title: Text('From Gallery'),
           ),
           ListTile(
             onTap: (){
               pickImage(ImageSource.camera);
             },
             leading: Icon(Icons.camera_alt),
             title: Text('From Camera'),
           ),
         ],
       ),
      );
    });
  }

  void CheckValues(){
    String name=fullnameController.text.trim();
    if(name=="" || pickedImage==""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter Valid Information')));
    }
    else{
      uploadData();
    }
  }

  void uploadData()async{
    UploadTask uploadTask=FirebaseStorage.instance.ref("profilepictures").child(widget.userModel.email.toString()).putFile(pickedImage!);
    TaskSnapshot snapshot=await uploadTask;
    String ? imageUrl=await snapshot.ref.getDownloadURL();
    String ? name=fullnameController.text.trim();
    widget.userModel.profilepic=imageUrl;
    widget.userModel.fullname=name;
    log(name);
    FirebaseFirestore.instance.collection("users").doc(widget.userModel.email).set(widget.userModel.toMap()).then((value) =>
        ScaffoldMessenger(child: SnackBar(content: Text('Data Uploaded'))),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(userModel: widget.userModel, firebaseUser:widget.firebaseuser)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Stack(
                  children:[
                    Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:20),
                      alignment: Alignment.center,
                      child: Stack(
                        children:[
                          GestureDetector(onTap:(){
                            pickImageOptions();
                          },
                            child: pickedImage != null ? CircleAvatar(
                             backgroundImage: FileImage(pickedImage!),
                              radius: 70,
                            ) : Icon(Icons.account_circle,size: 100),
                          ),
                          Positioned(
                              top:105,
                              left: 105,
                              child: Icon(Icons.camera_alt_outlined,size: 30,))
                        ]
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top:180),
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.black12
                        ),
                        child: TextField(
                          controller:fullnameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: '   Full Name',
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top:250),
                          height: 40,
                          width: 300,
                          child: ElevatedButton(onPressed: (){
                            CheckValues();
                          }, child: Text('Submit'))),
                    )
                  ]
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
  pickImage(ImageSource imageType)async{
    try{
      final photo=await ImagePicker().pickImage(source: imageType);
      if(photo==null)return;
      final tempImage=File(photo.path);
      setState(() {
        pickedImage=tempImage;
      });
    }catch(ex){
      log(ex.toString());
    }
  }

}
