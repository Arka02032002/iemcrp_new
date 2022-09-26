import'package:flutter/material.dart';
import 'package:iemcrp_new/services/auth.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {

  AuthService _auth= AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher'),
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
    );
  }
}
