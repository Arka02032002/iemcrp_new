import'package:flutter/material.dart';
import 'package:iemcrp_new/services/auth.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  AuthService _auth= AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
