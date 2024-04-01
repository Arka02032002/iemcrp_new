import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iemcrp_new/Widgets/AssignmentSubmissionsCard.dart';

import '../loading.dart';

class Submissions_data extends StatelessWidget {

  // String tid = Get.arguments[0];
  //
  // String stream = Get.arguments[1];
  //
  // String subject = Get.arguments[2];
  String tid,stream,subject;

  Submissions_data(this.tid,this.stream,this.subject);

  @override
  Widget build(BuildContext context) {
    print(stream);

    return
      // Scaffold(
      // appBar: AppBar(
      //   title: Text("Submissions"),
      //   backgroundColor: Colors.green[700],
      // ),
      // body:
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('assignments')
            .doc(stream)
            .collection('Assignment')
            .snapshots()
        ,
        builder: (context, snapshot) {
          // print(snapshot.data!);
          if (!snapshot.hasData) {
            return Loading();
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
                  "No data found ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ));
          } else {
            var doc=snapshot.data!.docs;
            return SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  for(var element in doc)
                  //           for(String stream in stream)
                  //             StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('assignments').doc('stream').collection('Assignment').snapshots(),
                  //                 builder: (context,snap){
                  //                     if (!snapshot.hasData) {
                  //                     return Loading();
                  //                     } else if (snap.data!.docs.isEmpty) {
                  //                     return Center(
                  //                     child: Text(
                  //                     "No data found ",
                  //                     style: TextStyle(
                  //                     fontSize: 18,
                  //                     ),
                  //                     ));
                  //                     } else {
                  //                     var doc=snap.data!.docs;
                  //                     for(var element in doc){
                    if(element.id==subject && element['Assigned By']==tid)
                      for(var students in element['submissions'])
                        AssignmentSubmissionCard(desc: students['Description'], name: students['Name'], enrollment:students['Enrollment'], url: students['FileUrl'])
                  //
                  //
                  //                     }
                  //
                  //                   return Text("No submissions");
                  //                     }
                  //
                  // }),

                ],
              ),
            );

          }
        },
      );
    // );
  }
}
