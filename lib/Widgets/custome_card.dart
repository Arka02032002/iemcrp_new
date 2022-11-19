import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  int period;
  dynamic isPresent;

  CustomCard({required this.period,required this.isPresent});

  @override
  Widget build(BuildContext context) {
    Color present = Color(0xff00e676);
    Color absent =Color(0xffd32f2f);
    if(isPresent==true) {
      return Card(
        // margin: EdgeInsets.all(5),
        elevation: null,
        child: Padding(
          padding: const EdgeInsets.only(left: 0,top: 0,right: 0,bottom: 15),
          child: Text("Period- $period",
            // textAlign: TextAlign.center,
            style: TextStyle(
              height: 2,
              fontSize: 25,
            ),),
        ),
        color: present,
      );
    }
    else{
      return Card(
        margin: EdgeInsets.all(8),
        elevation: null,
        child: Padding(
          padding: const EdgeInsets.only(left: 0,top: 0,right: 0,bottom: 15),
          child: Text("Period- $period",
            // textAlign: TextAlign.center,
            style: TextStyle(
              height: 2,
              fontSize: 25,
            ),),
        ),
        color: absent,

      );
    }
  }
}
