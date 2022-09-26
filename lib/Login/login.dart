import 'package:flutter/material.dart';
import 'package:iemcrp_new/services/auth.dart';
import 'package:iemcrp_new/shared/constants.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth=AuthService();
  final _formKey = GlobalKey<FormState>();


  //text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
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
                  child: Text('Sign in',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        // loading = true;
                      });
                      // log(email);
                      // log(password);
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
                          // loading = false;
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
