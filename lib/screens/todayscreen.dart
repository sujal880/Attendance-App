import 'dart:async';
import 'dart:developer';
import 'package:attendance/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
class TodayScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  TodayScreen({required this.userModel, required this.firebaseUser});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  String CheckIn="--/--";
  String CheckOut="--/--";
  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getRecord()async{
    try{
      QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("users").where("${widget.userModel.uid}").get();
      DocumentSnapshot snap2=await FirebaseFirestore.instance.collection("users").doc(widget.userModel.email).collection("Time").doc(DateFormat('dd MMMM yyyy').format(DateTime.now())).get();
      setState(() {
        CheckIn=snap2['CheckIn'];
        CheckOut=snap2['CheckOut'];
      });
    }
    catch(e){
      setState(() {
        CheckIn="--/--";
        CheckOut="--/--";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    return Scaffold(
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: width/40),
                    Container(
                      margin: EdgeInsets.only(top:100),
                      child: Text('Welcome',style: TextStyle(color: Colors.black54,fontSize: width/20),),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: width/40),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("${widget.userModel.fullname}",style: TextStyle(color: Colors.black,fontSize: width/18,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top:40),
                  alignment: Alignment.center,
                  child: Text("Today's Task",style: TextStyle(color: Colors.black54,fontSize: width/18,fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    margin: EdgeInsets.only(top:15,bottom: 32),
                    alignment: Alignment.centerLeft,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(2,2)
                          )
                        ],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Check In",style: TextStyle(fontSize: width/20,color: Colors.black54),),
                              Text(CheckIn,style: TextStyle(fontSize: width/18,color: Colors.black54,fontWeight: FontWeight.bold))
                            ],
                          ),
                        )),
                        Expanded(child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Check Out",style: TextStyle(fontSize: width/20,color: Colors.black54)),
                              Text(CheckOut,style: TextStyle(fontSize: width/18,color: Colors.black54,fontWeight: FontWeight.bold))
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                          text: DateTime.now().day.toString(),
                          style: TextStyle(
                              fontSize: width/18,
                              color: Colors.blue
                          ),
                          children: [
                            TextSpan(
                                text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                                style: TextStyle(fontSize: width/20,fontWeight: FontWeight.bold,color: Colors.black)
                            )
                          ]
                      ),
                    )
                ),
                StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(DateFormat('hh:mm:ss a').format(DateTime.now()),style: TextStyle(fontSize: width/20,color: Colors.black54),),
                      );
                    }
                ),
                CheckOut=="--/--" ?
                Padding(
                  padding: const EdgeInsetsDirectional.only(start:20,end: 20),
                  child: Container(
                    margin: EdgeInsets.only(top:120),
                    child: Builder(builder: (context){
                      final GlobalKey<SlideActionState> key=GlobalKey();
                      return SlideAction(
                        text:CheckIn=="--/--" ? "Slide to Check In" : "Slide to Check Out"
                        ,textStyle: TextStyle(color: Colors.black54,fontSize: width/20),
                        outerColor: Colors.white,
                        innerColor: Colors.blue,
                        key: key,
                        onSubmit: ()async{
                          Timer(Duration(seconds: 1), () {
                            key.currentState!.reset();
                          });
                          print(DateFormat('hh:mm').format(DateTime.now()));
                          QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("users").where("id",isEqualTo: widget.userModel.email).get();
                          log(snapshot.docs[0].id);
                          DocumentSnapshot snap2=await FirebaseFirestore.instance.collection("users").doc(widget.userModel.email).collection("Time").doc(DateFormat('dd MMMM yyyy').format(DateTime.now())).get();
                          try{
                            String CheckIn=snap2['CheckIn'];
                            setState(() {
                              CheckOut=DateFormat('hh:mm').format(DateTime.now());
                            });
                            await FirebaseFirestore.instance.collection("users").doc(widget.userModel.email).collection("Time").doc(DateFormat(' dd MMMM yyyy').format(DateTime.now())).update(
                                {
                                  'CheckIn':CheckIn,
                                  'CheckOut':CheckOut
                                });
                          }catch(ex){
                            setState(() {
                              CheckIn=DateFormat('hh:mm').format(DateTime.now());
                              CheckOut=DateFormat('hh:mm').format(DateTime.now());
                            });
                            await FirebaseFirestore.instance.collection("users").doc(widget.userModel.email).collection("Time").doc(DateFormat(' dd MMMM yyyy').format(DateTime.now())).set(
                                {
                                  'CheckIn':DateFormat('hh:mm').format(DateTime.now()),
                                  'CheckOut':DateFormat('hh:mm').format(DateTime.now())
                                });
                          }
                        },
                      );
                    }),
                  ),
                ):Container(
                    margin: EdgeInsets.only(top:50),
                    child:Text('You have completed this day!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                )
              ],
            ),
          ),
        )
    );
  }
}