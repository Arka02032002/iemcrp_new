import 'package:flutter/material.dart';
import 'package:iemcrp_new/Dashboard/Student/student_profile.dart';
import 'package:iemcrp_new/models/students.dart';
import 'package:iemcrp_new/services/auth.dart';
import 'package:iemcrp_new/services/datasbase.dart';
import 'package:provider/provider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  AuthService _auth= AuthService();

  @override


  Widget build(BuildContext context) {
    return StreamProvider<List<Student>?>.value(
    value: DatabaseService().students,
    initialData: null,
    catchError: (_, __) => null,
    child: Scaffold(
      appBar: AppBar(
          title: Text('Student'),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.brown[800],
              ),
              onPressed: () async {
                await _auth.signOut();
              },
              label:
              Text('logout', style: TextStyle(color: Colors.brown[800])),
            )
          ]
      ),
      backgroundColor: Colors.white,
      body: StudentProfile(),
    ),);
  }
}
