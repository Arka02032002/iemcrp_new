import 'package:flutter/material.dart';
import 'package:iemcrp_new/Dashboard/Student/student_home.dart';
import 'package:iemcrp_new/Dashboard/Teacher/teacher_home.dart';
class Dashboard extends StatelessWidget {

  bool isTeacher;
  Dashboard({required this.isTeacher});

  @override
  Widget build(BuildContext context) {

    if(isTeacher){
      return TeacherHome();
    }
    else {
      return StudentHome();
    }
  }
}
