import 'package:attendance/models/usermodel.dart';
import 'package:attendance/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Profile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  Profile({required this.userModel,required this.firebaseUser});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children:[
              Container(
                height: 200,
                width: 400,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blue,
                      Colors.white
                    ])
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top:110,start:20),
                child: Row(
                  children: [
                   Card(elevation: 12,
                     shape:RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(70)
                     ),
                     child: CircleAvatar(
                       radius: 70,
                       backgroundImage:NetworkImage("${widget.userModel.profilepic}")
                     ),
                   ),
                    SizedBox(width: 30),
                    Text("${widget.userModel.fullname}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
                  ],
                ),
              )
            ]
          ),
          Row(
            children: [
              SizedBox(width: 180),
              Text("${widget.userModel.organization}",style: TextStyle(fontSize: 25),),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 200),
              Text("${widget.userModel.desicnation}",style: TextStyle(fontSize: 18,color: Colors.grey),),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 30),
              Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.blue),
                ),
                child: Center(child: Text('Profile',style: TextStyle(fontSize: 18,color: Colors.blue),)),
              ),
              SizedBox(width: 20),
              Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.blue),
                ),
                child: Center(child: Text('Chart',style: TextStyle(fontSize: 18,color: Colors.blue),)),
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            children: [
              SizedBox(width: 30),
              Text('Email:-',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text("${widget.userModel.email}",style: TextStyle(fontSize: 20),)
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 30),
              Text('Phone:-',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text("${widget.userModel.phone}",style: TextStyle(fontSize: 20),)
            ],
          ),
          SizedBox(height: 90),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: GestureDetector(onTap:(){
              logOut();
            },
              child: Container(
                height: 70,
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.white,
                  ],
                  begin: Alignment.centerLeft,
                    end: Alignment.centerRight
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout,size: 28,),
                    SizedBox(width: 5),
                    Text('Log Out',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Future logOut()async{
    await FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login_Page())));
  }
}
