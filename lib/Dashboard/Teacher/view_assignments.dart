import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iemcrp_new/services/datasbase.dart';

import '../../Widgets/AssignmentCard.dart';
import '../../shared/constants.dart';
import '../loading.dart';

class ViewAssignment extends StatefulWidget {
  const ViewAssignment({Key? key}) : super(key: key);

  @override
  State<ViewAssignment> createState() => _ViewAssignmentState();
}

class _ViewAssignmentState extends State<ViewAssignment> {
  String teacher = Get.arguments[0];
  String stream=Get.arguments[1];
  int year =0;
  bool isYearChoosen=false;
  DatabaseService db = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Assignments"),
      ),
      body: !isYearChoosen?Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Enter Year'),
              onChanged: (val){
                setState(() {
                  year=int.parse(val);
                });
              },
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              setState(() {
                isYearChoosen=!isYearChoosen;
              });
            }, child: Text("Submit",style: TextStyle(fontSize: 18),))
          ],
        ),
      ):SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacher)
            .collection('Assignments-year $year')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "No data found 😥",
              style: TextStyle(
                fontSize: 18,
              ),
            ));
          } else {
            var doc = snapshot.data!.docs;
            return SingleChildScrollView(
              reverse: true,
              child: Column(
                children: <Widget>[
                  for (var element in doc)
                    // print(element[stream]);
                    AssignmentCard(
                      tid: teacher,
                      subject: element.id,
                      desc: element['Description'],
                      url: element['FileUrl'],
                      isStudent: false,
                      stream: element['stream'] ,
                      year: year,
                      // stream: stream,
                    )
                  // Text(element.id+'\n'+element['Description']+'\n'+element['FileUrl'])
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
