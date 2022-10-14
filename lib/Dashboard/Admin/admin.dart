import 'package:flutter/material.dart';
import 'package:iemcrp_new/Dashboard/loading.dart';
import 'package:iemcrp_new/services/auth.dart';
import 'package:iemcrp_new/services/datasbase.dart';
import 'package:iemcrp_new/shared/constants.dart';
import 'package:provider/provider.dart';




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

  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      appBar: AppBar(
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
      body: Container(

        //Sign In Anonymously
        // child: TextButton(
        //   onPressed: () async{
        //     dynamic result = await _auth.signInAnom();
        //     if(result==null){
        //       print("error signing in");
        //     }
        //     else{
        //       print(result.uid);
        //     }
        //   },
        //   child: Text('Sign In Anom'),
        // ),

        //Sign in with email and password
        child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Email'),
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
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
                  dynamic result = await _auth.registerWithEmailAndPassword(email, password);
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
