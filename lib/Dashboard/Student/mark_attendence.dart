import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iemcrp_new/Dashboard/loading.dart';
import 'package:iemcrp_new/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iemcrp_new/services/code.dart';
import 'package:provider/provider.dart';
import 'package:iemcrp_new/Dashboard/Teacher/form_creation.dart';

import '../../models/codes.dart';
import '../../models/students.dart';
import '../../models/user.dart';
import '../../shared/constants.dart';

class Mark_Attendence extends StatefulWidget {


  @override

  State<Mark_Attendence> createState() => _Mark_AttendenceState();
}

class _Mark_AttendenceState extends State<Mark_Attendence> {


  @override

  // bool correctCode=false;
  String code="";
  String status="";

  String enteredCode="";
  final CollectionReference codeCollection =FirebaseFirestore.instance.collection('codes');
  String studentStream=Get.arguments;


  // void getStream() {
  //   var document = codeCollection.doc(studentStream);
  //   // var docSnapshot = codeCollection.doc(studentStream).get();
  //   // if (docSnapshot.) {
  //   //   Map<String, dynamic>? data = docSnapshot.data();
  //   //   var value = data?['some_field']; // <-- The value you want to retrieve.
  //   //   // Call setState if needed.
  //   // }
  //   document.get().then((value) {
  //     log("----DATA---");
  //     // var fields=value.data();
  //     Object? data = value.data();
  //     data
  //     // log(fields);
  //     log(value.data().toString());
  //     // value.data().forEach()
  //
  //     // code=fields['code'];
  //   });
  // }



  // final CollectionReference studentCollection =FirebaseFirestore.instance.collection('students');





  Widget build(BuildContext context) {
    // log(studentStream);
    var document = codeCollection.doc(studentStream);
    // String code="";



    // final students=Provider.of<List<Student>?>(context);
    // Object stream= studentCollection.doc(studentID).get('stream') ?? '';
    // codeCollection.doc(studentStream).get().then((QuerySnapshot snapshot){
    //   log("----DATA---");
    //   // dynamic fields=value.data();
    //   // print(fields['code']);
    //   // log(value.data().toString());
    //   value.data().forEach()
    //
    //   // code=fields['code'];
    // });
    // user.
    // getStream();
    return StreamBuilder<QuerySnapshot>(
      stream: codeCollection.snapshots(),
      builder: (context,  snapshot) {


        if (!snapshot.hasData) {
          return Loading();
        }
        var doc = snapshot.data!.docs;
        doc.forEach((element) {
            // log(element.id);
            // print(element.id.length);
            // log(studentStream);
            // log(studentStream.length.toString());
            // log(element['code']);
            // code = element['code'];

            if(element.id==studentStream) {
          // log("hi");
          //     log(element['code']);
            // setState((){
              code = element['code'];
            // });
          }
            log(code);



        });
        // // log(doc['code']);
        // log(snapshot.data!.docs.length.toString());
        // code=doc['code'];
        // log(code);

        // for(int i=0;i<snapshot.data!.docs.length;i++) {
        //   DocumentSnapshot doc = snapshot.data!.docs[i];
        //   log(doc.id);
        //   log(studentStream);
        //   if(doc.id==studentStream) {
        //     log(doc['code']);
        //     // setState((){
        //       code = doc["code"];
        //     // });
        //   }
        //   log(code);
        // }



        // final docs = snapshot.data?.docs;
        // final data =docs[0]?.data();
        // log(docs[0].data());
        // log(codes!["code"]);
        return Scaffold(
          appBar: AppBar(
            title:Text("Mark Attendence"),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Enter Code'),
                  onChanged: (val){
                    setState(() {
                      enteredCode=val;
                    });
                    // enteredCode=val;
                    // log(globals.code);
                    // if(doc["code"]==val)
                    //   correctCode=true;
                    // else
                    //   correctCode=false;
                  },

                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  log(code);

                  log("ENTERED CODE"+ enteredCode);
                  if(code==enteredCode) {
                    setState(() {
                      status="Attendence Marked";
                    });

                    log("Attendence Marked");
                  }
                  else {
                    setState(() {
                      status="Invalid Code";
                    });
                    log("-----No-----");
                  }
                },

                    child: Text("Mark Attendence",
                      style: TextStyle(
                          fontSize: 20
                      ),)
                ),
                Text(status),
              ],
            ),

          ),
        );
      }
    );
  }
}
