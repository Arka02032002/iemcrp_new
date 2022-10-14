import 'package:flutter/material.dart';
import 'package:iemcrp_new/Dashboard/Admin/admin.dart';
import 'package:iemcrp_new/Dashboard/Student/student_home.dart';
import 'package:iemcrp_new/Dashboard/Teacher/teacher_home.dart';
class Dashboard extends StatelessWidget {

  String role;
  Dashboard({required this.role});

  @override
  Widget build(BuildContext context) {

    if(role=='t'){
      return TeacherHome();
    }
    else if(role=='s'){
      return StudentHome();
    }
    else{
      return Admin();
    }
  }
}
