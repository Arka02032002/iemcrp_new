import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
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
    return GetMaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: StreamProvider<IemcrpUser?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (_, __) => null,
          child: Wrapper()),
    );
  }
}



