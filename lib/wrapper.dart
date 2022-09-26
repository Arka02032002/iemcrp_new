import 'package:flutter/material.dart';
import 'package:iemcrp_new/Dashboard/dashboard.dart';
import 'package:iemcrp_new/Login/login.dart';
import 'package:iemcrp_new/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<IemcrpUser?>(context);
    print(user?.uid);




    //return either dashboard or login
    if (user == null) {
      return Login();
    } else {
      return Dashboard();
    }
  }
}
