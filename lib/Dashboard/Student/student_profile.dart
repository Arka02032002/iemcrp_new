import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iemcrp_new/Dashboard/Student/mark_attendence.dart';
import 'package:iemcrp_new/Widgets/Buttons_small.dart';
import 'package:iemcrp_new/models/students.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../screens/welcome/welcome_screen.dart';
import '../loading.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {

    final students=Provider.of<List<Student>?>(context);
    final user = Provider.of<IemcrpUser?>(context);
    var name="";
    // var id="";
    var stream="";
    String enrollment="";
    void getStudentData() async {
      for (var student in students!) {
        if (student.id == user?.uid) {
          name = (student.name);
          enrollment = student.enrollment;
          stream = student.stream;
        }
      }
    }
    getStudentData();

    // print(students[0].);
      return students==null ? Loading():SingleChildScrollView(

        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 5),

                        child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: const Color(
                                    0xFF0040c2))),
                            child: Container(
                              width: 145,
                              height: 145,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://images.pexels.com/photos/428364/pexels-photo-428364.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                                      fit: BoxFit.cover)),
                            )),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: Text(name,
                          // "Arka",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Stream',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Text(
                              stream,
                              style:
                              TextStyle(fontSize: 19, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Univ. Roll no.',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Text(
                              enrollment,
                              style:
                              TextStyle(fontSize: 19, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.only(left: 28, right: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Buttons_small(

                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Give Attendence',
                        ontap: () => Get.to(Mark_Attendence(),arguments: stream),
                        icon: Icons.edit,
                        size: 150,
                      ),
                      Buttons_small(
                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Edit',
                        icon: Icons.save,
                        size: 150,
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.only(left: 28, right: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Buttons_small(
                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Edit',
                        icon: Icons.edit,
                        size: 150,
                      ),
                      Buttons_small(
                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Edit',
                        icon: Icons.save,
                        size: 150,
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.only(left: 28, right: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Buttons_small(
                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Edit',
                        icon: Icons.edit,
                        size: 150,
                      ),
                      Buttons_small(
                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Edit',
                        icon: Icons.save,
                        size: 150,
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }
}
