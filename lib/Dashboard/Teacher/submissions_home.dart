import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iemcrp_new/Dashboard/Teacher/submissions.dart';
import 'package:iemcrp_new/Widgets/AssignmentSubmissionsCard.dart';

import '../loading.dart';

class Submissions extends StatefulWidget {
  const Submissions({Key? key}) : super(key: key);

  @override
  State<Submissions> createState() => _SubmissionsState();
}

class _SubmissionsState extends State<Submissions> {
  String tid = Get.arguments[0];
  List stream = Get.arguments[1];
  String subject = Get.arguments[2];
  @override
  Widget build(BuildContext context) {
    print(stream);

    return Scaffold(
        appBar: AppBar(
          title: Text("Submissions"),
          backgroundColor: Colors.green[700],
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
              children: [
                for(String stream in stream)
                  Submissions_data(tid,stream,subject)
              ]
          ),
        )
    );
  }}


