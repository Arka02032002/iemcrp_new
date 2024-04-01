import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iemcrp_new/Dashboard/Student/submit_assignment.dart';

import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Dashboard/Teacher/submissions.dart';
import '../Dashboard/Teacher/submissions_home.dart';

class AssignmentCard extends StatelessWidget {
  String subject = 'Aiml';
  String desc = 'test';
  String ?url = 'https://www.google.com/';
  String ?sid='';
  String ?tid='';
  String ?name='';
  String ?enrollment='';
  bool isStudent;
  List? stream=[];
  List students=[];
  String buttonText='';


  AssignmentCard({required this.subject, required this.desc, this.url,required this.isStudent,this.sid,this.name,this.enrollment,this.stream,this.tid});

  @override
  Widget build(BuildContext context) {
    print("here");
    if(isStudent){
      buttonText="Submit";
    }
    else{
      buttonText="Submissions";
    }
    return Card(
      // shadowColor: Colors.blueGrey,
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((10))),
  
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          color: Colors.grey[200],

          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(subject),
                    SizedBox(
                      height: 10,
                    ),
                    Text(desc),
                    SizedBox(
                      height: 10,
                    ),
                    Linkify(
                      text: url!,
                      onOpen: _onOpen,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            if(isStudent)
                            Get.to(Assignment_stream(),arguments: [sid,name,enrollment,stream?[0],subject]);
                            else
                              // for(String stream in stream!)
                              Get.to(Submissions(),arguments: [tid,stream,subject]);
                          },
                          child: Text(buttonText),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future _onOpen(LinkableElement link) async {
    await launchUrl(Uri.parse(link.url));
  }
}
