import 'dart:developer';
import 'package:attendance/models/usermodel.dart';
import 'package:attendance/screens/homescreen.dart';
import 'package:attendance/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);
  @override
  State<Login_Page> createState() => _Login_PageState();
}
class _Login_PageState extends State<Login_Page> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  void SignIn()async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    UserCredential? credential;

    if(email=="" || password==""){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Enter Valid Details'),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Ok'))
          ],
        );
      });
    }
    else{
      try{
        credential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }on FirebaseAuthException catch(ex){
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text(ex.code.toString()),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Ok'))
            ],
          );
        });
      }
      if(credential!=null){
        String uid=credential.user!.uid;
        DocumentSnapshot userData=await FirebaseFirestore.instance.collection("users").doc(email).get();
        UserModel userModel=UserModel.fromMap(userData.data() as Map<String,dynamic>);
        log('Logged In');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(userModel: userModel,firebaseUser: credential!.user!,)));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.white,
                  ],begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Stack(
                    children:[
                      Card(
                        elevation:16,
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          height: 400,
                          width: 400,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:Colors.white
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top:60),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text('Sign In',style: TextStyle(fontSize: 22))),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top:120),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 45,
                              width: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black12
                              ),
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    prefixIcon: Icon(Icons.person),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top:180),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 45,
                              width: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black12
                              ),
                              child: TextField(
                                controller: passwordController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: Icon(Icons.remove_red_eye),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top:245),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 20),
                              SizedBox(
                                  height: 40,
                                  width: 130,
                                  child: ElevatedButton(onPressed: ()async{
                                    SignIn();
                                  }, child: Text('Sign In'),style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),backgroundColor: Colors.blue),)),
                              SizedBox(width: 20),
                              TextButton(onPressed: (){}, child: Text('Forgotten Password?'))
                            ]
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top:320),
                        child: Center(child: TextButton(onPressed: (){
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Create()));
                        }, child: Text('Create a New Account'))),
                      )
                    ]
                ),
              )
            ],
          ),
        )
    );
  }
}
