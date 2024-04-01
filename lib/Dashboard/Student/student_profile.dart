import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iemcrp_new/Dashboard/Student/check_attendance.dart';
import 'package:iemcrp_new/Dashboard/Student/fees_dashboard.dart';
import 'package:iemcrp_new/Dashboard/Student/mark_attendence.dart';
import 'package:iemcrp_new/Dashboard/Student/register_face.dart';
import 'package:iemcrp_new/Dashboard/Student/viewAttendance.dart';
import 'package:iemcrp_new/Dashboard/Student/viewPayment.dart';
import 'package:iemcrp_new/Dashboard/Student/view_assignments.dart';
import 'package:iemcrp_new/Widgets/Buttons_small.dart';
import 'package:iemcrp_new/models/students.dart';
import 'package:iemcrp_new/services/datasbase.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../loading.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  var name="";
  String id="";
  var stream="";
  var course="";
  String email='';
  String enrollment="";
  var phone="";
  int year=0;
  @override
  Widget build(BuildContext context)  {

    final students=Provider.of<List<Student>?>(context);
    final user = Provider.of<IemcrpUser?>(context);
    // Student student=DatabaseService().getStudentById(user!.uid);

    // print(user!.uid);

    void getStudentData() async {

      for (var student in students!) {
        if (student.id == user?.uid) {
          id=student.id;
          name = student.name;
          enrollment = student.enrollment;
          stream = student.stream;
          id=student.id;
          course=student.course;
          email=student.email;
          phone=student.phone;
          year=student.year;
          print(year);
        }
      }
      // setState(() {
      //
      // });
    }
    getStudentData();
    log("STUDENT-ID----"+ id);
    log("STUDENT--YEAR"+year.toString());


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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

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
                      ),                      SizedBox(width: 10,),

                      IconButton(onPressed: (){
                        Get.to(ViewAttendance(),arguments: id);
                      },
                        icon: FaIcon(FontAwesomeIcons.solidCalendarDays,
                          color: Colors.amber,
                          size: 28,
                        ),),
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
                              'Course',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Text(
                              course,
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
                  height: 10,
                ),
                SizedBox(
                  height: 10,
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
                        text: 'Mark Attendance',
                        ontap: () => Get.to(Mark_Attendence(),arguments: [stream,id,year]),
                        icon: Icons.playlist_add_check_circle_outlined,
                        size: 150,
                      ),
                      Buttons_small(
                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Assignments',
                        ontap: () => Get.to(View_Assignments(),arguments: [id,stream,name,enrollment,year]),
                        // ontap: () => Get.to(AssignmentCard()),

                        icon: Icons.assignment,

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
                        text: 'Check Attendance ',
                        icon: Icons.percent_rounded,
                        ontap: () => Get.to(CheckAttendance(),arguments: id),
                        size: 150,
                      ),
                      Buttons_small(
                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Pay Fees',
                        ontap: ()=> Get.to(FeesDashboard(),arguments: [course,email,phone,id,name,enrollment,stream,year]),
                        icon: Icons.currency_rupee_rounded,
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
                        text: 'Payment Records',
                        ontap: ()=> Get.to(ViewPayments(),arguments: id),
                        icon: Icons.list_alt,
                        size: 150,
                      ),
                      Buttons_small(
                        Textcolor: Colors.black,
                        BackgroundColor: Colors.grey.withOpacity(0.2),
                        text: 'Register FaceID',
                        ontap: ()=> Get.to(RegisterFace(),arguments: [id,course,stream,year]),
                        icon: Icons.account_circle,
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
