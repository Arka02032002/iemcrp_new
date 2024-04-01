import 'package:flutter/material.dart';
import 'package:iemcrp_new/Dashboard/loading.dart';
import 'package:iemcrp_new/services/auth.dart';
import 'package:iemcrp_new/shared/constants.dart';




class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override

  AuthService _auth= AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading= false;


  //text field state
  String email = "";
  String password = "";
  String error = "";
  String name = "";
  String stream= "";
  String enrollment= "";
  String course="";
  int salary=0;
  int year=0;
  String phone='';

  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Admin"),

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
      body: SingleChildScrollView(


        //Sign in with email and password
        child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration: textInputDecoration.copyWith(hintText: 'Email'),
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration:
              textInputDecoration.copyWith(hintText: 'Password'),
              obscureText: true,
              validator: (val) =>
              val!.length < 6 ? 'Enter a password 6+ chars long' : null,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration:
              textInputDecoration.copyWith(hintText: 'Phone No.'),
              obscureText: false,
              validator: (val) =>
              (val!.length < 7 || val!.length >15) ? 'Not a valid phone no.' : null,
              onChanged: (val) {
                setState(() => phone = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration:
              textInputDecoration.copyWith(hintText: 'Name'),
              // obscureText: true,
              validator: (val) =>
              val!.length < 1 ? 'Name should be more thean 1 letter' : null,
              onChanged: (val) {
                setState(() => name = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration:
              textInputDecoration.copyWith(hintText: 'Stream'),
              // obscureText: true,
              validator: (val) =>
              val!.length < 1 ? 'Stream should be more thean 1 letter' : null,
              onChanged: (val) {
                setState(() => stream = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration:
              textInputDecoration.copyWith(hintText: 'Course'),
              // obscureText: true,
              validator: (val) =>
              val!.length < 1 ? 'Course should be more thean 1 letter' : null,
              onChanged: (val) {
                setState(() => course = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration:
              textInputDecoration.copyWith(hintText: 'Enrollment No'),
              // obscureText: true,
              validator: (val) =>
              val!.length < 0 ? 'Enrollment number should be more thean 0 digit' : null,
              onChanged: (val) {
                setState(() => enrollment = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration:
              textInputDecoration.copyWith(hintText: 'Salary'),
              // obscureText: true,
              validator: (val) =>
              val!.length < 0 ? 'Salary should be more thean 1 digit' : null,
              onChanged: (val) {
                setState(() => salary = int.parse(val));
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              scrollPadding: EdgeInsets.only(bottom:40),
              decoration:
              textInputDecoration.copyWith(hintText: 'Year'),
              // obscureText: true,
              validator: (val) =>
              val!.length <0 ? 'Year should be less thean 2 digit' : null,
              onChanged: (val) {
                setState(() => year = int.parse(val));
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pink[400],
              ),
              child: Text('Register user',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  // log(email);
                  // log(password);
                  dynamic result = await _auth.registerWithEmailAndPassword(email, password,name,stream,enrollment,salary,year,course,phone);
                  print(result);
                  if (result == null) {
                    setState(() {
                      error = 'please enter a valid email';
                      loading = false;
                    });
                  }
                  else{
                    setState(() {
                      error = result;
                      loading = false;
                    });

                  }
                }
              },
            ),
            SizedBox(height: 15),
            Text(error, style: TextStyle(color: Colors.red, fontSize: 14))
          ],
        )),

    ),
    );
  }
}
