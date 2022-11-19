import 'package:flutter/material.dart';
import 'package:iemcrp_new/Widgets/custome_card.dart';

class Attendance_Report extends StatefulWidget {
  Map<String,dynamic> attendanceData;

  Attendance_Report({required this.attendanceData});

  @override
  State<Attendance_Report> createState() => _Attendance_ReportState();
}

class _Attendance_ReportState extends State<Attendance_Report> {


  @override
  Widget build(BuildContext context) {
    // return Text(widget.attendanceData['2'].toString());
    // for(int i=0;i<8;i++){
    //   return
    // }
    return Column(
      children: [
        CustomCard(period: 1, isPresent:widget.attendanceData['1']),
        CustomCard(period: 2, isPresent:widget.attendanceData['2']),
        CustomCard(period: 3, isPresent:widget.attendanceData['3']),
        CustomCard(period: 4, isPresent:widget.attendanceData['4']),
        CustomCard(period: 5, isPresent:widget.attendanceData['5']),
        CustomCard(period: 6, isPresent:widget.attendanceData['6']),
        CustomCard(period: 7, isPresent:widget.attendanceData['7']),
        CustomCard(period: 8, isPresent:widget.attendanceData['8']),


      ],
    );

  }
}

