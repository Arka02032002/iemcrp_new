import 'package:flutter/material.dart';
import 'package:iemcrp_new/Dashboard/dashboard.dart';
import 'package:iemcrp_new/Login/login.dart';
import 'package:iemcrp_new/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override

  //  String determineRole(IemcrpUser? user) {
  //  if(user?.creationdt==user?.lastsignindt){
  //     // print("equal");
  //     return 'a';
  //   }
  //   else
  //     return 's';
  // }


  Widget build(BuildContext context){

    final user = Provider.of<IemcrpUser?>(context);
    // print(user);
    String role='s';
    String? email = user?.email;
    // print("METADATA::::\n");
    // print(user?.creationdt);
    // print(user?.lastsignindt);

    // role= determineRole(user);
    // if(role==null){
      // if(user.metadata.)
      if (email != null) {
        if (email.contains("iemcal")) {
          if (email == 'sourav@iemcal.com') {
            role = 'a';
          }
          else {
            role = 't';
          }
        }
        else {
          role = 's';
        }
      }
    // }
    // print("IS TEACHER");
    // print(isTeacher);




    //return either dashboard or login
    if (user == null) {
      return Login();
    } else {
      return Dashboard(role: role);
    }
  }
}
