import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iemcrp_new/Dashboard/Teacher/form_creation.dart';
import 'package:iemcrp_new/Dashboard/Teacher/mark_attendance.dart';
import 'package:iemcrp_new/Dashboard/Teacher/view_assignments.dart';
import 'package:iemcrp_new/Widgets/Buttons_small.dart';
import 'package:iemcrp_new/models/teachers.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../loading.dart';
import 'assignment.dart';

class TeacherProfile extends StatefulWidget {

  @override

  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {

  @override


  Widget build(BuildContext context){

    final teachers= Provider.of<List<Teacher>?>(context);
    final user = Provider.of<IemcrpUser?>(context);
    var name="";
    String stream="";
    print("----------TEACHERS---------");
    // while(teachers!=null) {
    void getTeacherData() async {
      for (var teacher in teachers!) {
        if (teacher.id == user?.uid) {
          name = (teacher.name);
          stream=teacher.stream;
        }
      }
    }
    getTeacherData();
    // }
    // final CollectionReference questionCollection =FirebaseFirestore.instance.collection('questions');


    return teachers==null ? Loading():SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 5),
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: const Color(0xFF0040c2))),
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
                      child: Text(
                        name,
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
                            style: TextStyle(
                                fontSize: 19, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Attended',
                    //         style: TextStyle(
                    //             fontSize: 19,
                    //             color: Colors.black,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(width: 5),
                    //       Text(
                    //         '10',
                    //         style: TextStyle(
                    //             fontSize: 19, color: Colors.black),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 28, right: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Buttons_small(
                      Textcolor: Colors.black,
                      BackgroundColor: Colors.grey.withOpacity(0.2),
                      text: 'Create Attendence',
                      ontap: () => Get.to(Create_Attendance()),
                      icon: Icons.playlist_add_circle_outlined,
                      size: 150,
                    ),
                    Buttons_small(
                      Textcolor: Colors.black,
                      BackgroundColor: Colors.grey.withOpacity(0.2),
                      text: 'New Assignment',
                      ontap: () => Get.to(Assignment_stream(),arguments: [user?.uid,stream]),
                      icon: Icons.assignment_add,
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
                      text: 'All Assignments',
                      ontap: () => Get.to(ViewAssignment(),arguments: [user?.uid,stream]),
                      icon: Icons.assignment,
                      size: 150,
                    ),
                    Buttons_small(
                      Textcolor: Colors.black,
                      BackgroundColor: Colors.grey.withOpacity(0.2),
                      text: 'Mark Attendance',
                      ontap: () => Get.to(MarkAttendance(),),
                      icon: Icons.camera_alt_outlined,
                      size: 150,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
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
                      icon: Icons.save,
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
