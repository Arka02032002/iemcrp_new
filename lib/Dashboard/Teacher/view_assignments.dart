import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iemcrp_new/services/datasbase.dart';

import '../../Widgets/AssignmentCard.dart';
import '../loading.dart';

class ViewAssignment extends StatefulWidget {
  const ViewAssignment({Key? key}) : super(key: key);

  @override
  State<ViewAssignment> createState() => _ViewAssignmentState();
}

class _ViewAssignmentState extends State<ViewAssignment> {
  String teacher = Get.arguments[0];
  String stream=Get.arguments[1];
  DatabaseService db = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Assignments"),
      ),
      body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacher)
            .collection('Assignments')
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
