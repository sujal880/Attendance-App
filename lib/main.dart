import 'package:attendance/models/firebasehelper.dart';
import 'package:attendance/models/usermodel.dart';
import 'package:attendance/screens/homescreen.dart';
import 'package:attendance/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
var uuid=Uuid();

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentuser=FirebaseAuth.instance.currentUser;
  if(currentuser!=null){
    //Logged In
    UserModel? thisUserModel=await FirebaseHelper.getUserModelById(currentuser.email!);
    if(thisUserModel!=null){
      runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseuser: currentuser));
    }
    else{
      runApp(MyApp());
    }
  }
  else{
    runApp(MyApp());
  }
}

//Not Logged In
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login_Page()
    );
  }
}


//Logged In
class MyAppLoggedIn extends StatelessWidget{
  final UserModel userModel;
  final User firebaseuser;
  MyAppLoggedIn({required this.userModel,required this.firebaseuser});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomeScreen(userModel: userModel,firebaseUser: firebaseuser),
    );
  }
  
}