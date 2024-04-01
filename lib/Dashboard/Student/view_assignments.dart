
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iemcrp_new/Widgets/AssignmentCard.dart';

import '../loading.dart';

class View_Assignments extends StatefulWidget {
  const View_Assignments({Key? key}) : super(key: key);

  @override
  State<View_Assignments> createState() => _View_AssignmentsState();
}

class _View_AssignmentsState extends State<View_Assignments> {
  
  String stream=Get.arguments[1];
  String id=Get.arguments[0];
  String name=Get.arguments[2];
  String enrollment=Get.arguments[3];
  int year=Get.arguments[4];

  @override
  Widget build(BuildContext context) {
    print(year);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title:Text("Assignments"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('assignments').doc(stream).collection(year.toString()).snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData) {
              return Loading();
            }
            else if(snapshot.data!.docs.isEmpty){
              return Center(
                  child: Text("No data found 😥",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ));
            }
            else{
              var doc=snapshot.data!.docs;

              return Column(
                children: <Widget>[
              for(var element in doc)

                if(!element['students'].contains(id))
                AssignmentCard(subject: element.id,desc: element['Description'],url: element['FileUrl'], isStudent: true,sid: id,name: name,enrollment: enrollment,stream: [stream],year:year)
                // Text(element.id+'\n'+element['Description']+'\n'+element['FileUrl'])
                ],
              );

            }
          },
        ),
      ),
    );
  }
}
