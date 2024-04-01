import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CheckAttendance extends StatefulWidget {
  @override
  State<CheckAttendance> createState() => _CheckAttendanceState();
}

class _CheckAttendanceState extends State<CheckAttendance> {
  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  String validDate="";
  String id = Get.arguments;
  int classesAttended = 0, classesHeld = 0;
  double attendancepercentage=0;
  bool showpercent=false;

  @override
  void initState() {
    startDateInput.text = ""; //set the initial value of text field
    endDateInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Attendace %"),
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: [
            TextField(
                controller: startDateInput,
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Start Date" //label text of field
                    ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      startDateInput.text =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                }),
            SizedBox(
              height: 25,
            ),
            TextField(
                controller: endDateInput,
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "End Date" //label text of field
                    ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      endDateInput.text =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                }),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   width: 250,
                //   child: TextField(
                //     controller: attendancepercent,
                //     decoration: InputDecoration(
                //         icon: Icon(Icons.percent_rounded), //icon of text field
                //         labelText: "Attendance %" //label text of field
                //         ),
                //     readOnly: true,
                //   ),
                // ),
                ElevatedButton(
                    onPressed: () async {
                      classesHeld=0;
                      classesAttended=0;
                      log("Entered onpressed");
                      print("Student id-----------" + id);
                      if(startDateInput.text=="" || endDateInput.text==""){
                        setState(() {
                          validDate="Invalid entry";
                        });
                      }
                      else{
                        setState(() {
                          validDate="";
                        });
                      }
                      DateTime startdate = DateTime.parse(startDateInput.text);
                      DateTime enddate = DateTime.parse(endDateInput.text);

                      FirebaseFirestore.instance
                          .collection('students')
                          .doc(id)
                          .collection('attendance')
                          .snapshots()
                          .forEach((QuerySnapshot snapshot) async {
                        for (var element in snapshot.docs) {
                          log(element.id);
                          DateTime dt = DateTime.parse(element.id);
                          if (dt.compareTo(startdate) >= 0 &&
                              dt.compareTo(enddate) <= 0) {
                            print("-------True---------");
                            Map<String, dynamic> record =
                                element.data() as Map<String, dynamic>;

                            for (var keys in record.keys) {
                              // print(keys + " : " + record[keys]!);
                              if(record[keys]=='attended') {
                                print("-----Attended");
                                classesAttended += 1;
                                classesHeld += 1;
                                // print("Classes held------"+ classesHeld.toString());

                              }
                              else if(record[keys]=='not attended'){
                                print("----- not Attended");

                                classesHeld+=1;
                              }
                            }
                          }
                        }
                        log("Classes attended------"+ classesAttended.toString());
                        print("Classes held------"+ classesHeld.toString());
                        attendancepercentage = (classesAttended/classesHeld);
                        setState(() {
                          showpercent=true;
                        });
                      });
                    },

                    child: Text("Calculate"))
              ],
            ),
            Text(validDate),
            SizedBox(height: 140,),
            Visibility(
              visible: showpercent,
              child: CircularPercentIndicator(
                radius: 120.0,
                animation: true,
                animationDuration: 2000,
                lineWidth: 20.0,
                percent: attendancepercentage,
                center: Text((attendancepercentage*100).toInt().toString()+" %",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.lightGreenAccent[200]!,
                progressColor: Colors.teal[800],
              ),
            ),

          ],
        ));
  }
}
