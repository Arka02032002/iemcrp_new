import 'package:flutter/material.dart';
import 'package:iemcrp_new/Widgets/Buttons_small.dart';
import 'package:iemcrp_new/models/students.dart';
import 'package:provider/provider.dart';

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
                      Container(
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
                      Container(
                        child: Text(students[0].name,
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
                  padding: const EdgeInsets.only(left: 48.0, right: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Classes',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '10',
                              style:
                              TextStyle(fontSize: 19, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Attended',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '10',
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
                  height: 25,
                ),
                SizedBox(
                  height: 25,
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
                        text: 'Mark Attendence',
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
