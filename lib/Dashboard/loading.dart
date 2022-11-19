import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green[700],
        child: Center(
          child: SpinKitCircle(
            color: Colors.white,
            size: 50,
          ),
        ));
  }
}
