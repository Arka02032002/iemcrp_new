import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iemcrp_new/Login/login.dart';
import 'package:iemcrp_new/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:iemcrp_new/services/auth.dart';
import 'package:iemcrp_new/models/user.dart';

Future <void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamProvider<IemcrpUser?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (_, __) => null,
          child: Wrapper()),
    );
  }
}



