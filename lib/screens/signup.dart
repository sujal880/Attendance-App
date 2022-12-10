import 'dart:developer';
import 'package:attendance/models/usermodel.dart';
import 'package:attendance/screens/sign_in.dart';
import 'package:attendance/screens/userdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);
  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController orgController=TextEditingController();
  TextEditingController desicnationController=TextEditingController();

  void SignUp()async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    String phone=phoneController.text.trim();
    String org=orgController.text.trim();
    String desic=desicnationController.text.trim();

    if(email=="" || password=="" || phone=="" || org=="" || desic==""){
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
      UserCredential ? userCredential;
      try{
        userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
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
      if(userCredential!=null){
        String uid=userCredential.user!.uid;
        UserModel newUser=UserModel(
            uid: uid,
            email: email,
            phone: phone,
          organization:org,
          desicnation:desic,
          fullname: "",
          profilepic: "",
        );
        await FirebaseFirestore.instance.collection("users").doc(email).set(newUser.toMap()).then((value) => log("User Created"));
        log(uid);
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>UserDetails(userModel: newUser,firebaseuser: userCredential!.user!)));
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
                      Card(elevation: 16,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          height: 500,
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
                            child: Text('Sign Up',style: TextStyle(fontSize: 22))),
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
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    prefixIcon: Icon(Icons.mail),
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
                                obscureText: true,
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
                        padding: const EdgeInsetsDirectional.only(top:240),
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
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: 'Phone',
                                    prefixIcon: Icon(Icons.phone),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top:300),
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
                                controller: orgController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: 'Organization Name',
                                    prefixIcon: Icon(Icons.maps_home_work),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top:360),
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
                                controller: desicnationController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: 'Desicnation',
                                    prefixIcon: Icon(Icons.person),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top:420,start:20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 20),
                            SizedBox(
                                height: 40,
                                width: 130,
                                child: ElevatedButton(onPressed: (){
                                  SignUp();
                                }, child: Text('Sign Up'),style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),backgroundColor: Colors.blue),)),
                            SizedBox(width: 50),
                            TextButton(onPressed: (){
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login_Page()));
                            }, child: Text('Sign In'))
                          ],
                        ),
                      ),
                    ]
                ),
              )
            ],
          ),
        )
    );
  }
}
