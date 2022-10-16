import 'package:flutter/material.dart';
import 'package:iemcrp_new/Dashboard/Teacher/teacher_profile.dart';
import 'package:iemcrp_new/models/teachers.dart';
import 'package:iemcrp_new/services/auth.dart';
import 'package:iemcrp_new/services/datasbase.dart';
import 'package:provider/provider.dart';
class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // print(teachers[0].name);

    // return Text("Hello");

    return StreamProvider<List<Teacher>?>.value(
        value: DatabaseService().teachers,
        initialData: null,
        catchError: (_, __) => null,
        child: Scaffold(
          appBar: AppBar(title: Text('Teacher'), actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.brown[800],
              ),
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text('logout', style: TextStyle(color: Colors.brown[800])),
            )
          ]),
          backgroundColor: Colors.white,
          body: TeacherProfile(),
        ));
  }
}
