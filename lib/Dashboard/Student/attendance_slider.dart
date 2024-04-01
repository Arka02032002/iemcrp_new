import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iemcrp_new/Widgets/attendance_report.dart';
import 'package:intro_slider/intro_slider.dart';

import '../loading.dart';

class AttendanceSlider extends StatefulWidget {
  String id = "";

  AttendanceSlider({required this.id});

  @override
  State<AttendanceSlider> createState() => _AttendanceSliderState();
}

class _AttendanceSliderState extends State<AttendanceSlider> {
  String date = "";

  @override
  Widget build(BuildContext context) {
    List<ContentConfig> listContentConfig = [];
    Color activeColor = const Color(0xff66bb6a);
    Color inactiveColor = const Color(0xff1b5e20);
    double sizeIndicator = 20;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(widget.id)
            .collection('attendance')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          else if(snapshot.data!.docs.isEmpty){
            return Center(
                child: Text("No data found 😥",
                  style: TextStyle(
                    fontSize: 18,
                  ),
            ));
          }
          else {


            var doc = snapshot.data!.docs;
            for (var element in doc.reversed) {
              date = element.id;
              final attendanceData=element.data() as Map<String,dynamic>;
              listContentConfig.add(
                ContentConfig(
                  title: date,
                  // description: "Lorem ipsum dolor sit amet, ",
                  styleDescription: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                  ),
                  marginDescription: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                    bottom: 70.0,
                  ),
                  // centerWidget: Attendance_Report(attendanceData: attendanceData),
                  centerWidget: Attendance_Report(attendanceData: attendanceData),
                  backgroundNetworkImage: "https://picsum.photos/600/900",

                  backgroundFilterOpacity: 0.5,
                  backgroundFilterColor: Colors.redAccent,
                  onCenterItemPress: () {},

                ),
              );
            }
            void onDonePress() {
              log("onDonePress caught");
            }

            void onNextPress() {
              log("onNextPress caught");
            }


            Widget renderNextBtn() {
              return const Icon(
                Icons.navigate_next,
                size: 25,
              );
            }

            Widget renderDoneBtn() {
              return const Icon(
                Icons.done,
                size: 25,
              );
            }

            Widget renderSkipBtn() {
              return const Icon(
                Icons.skip_next,
                size: 25,
              );
            }
            Widget renderPrevBtn() {
              return const Icon(
                Icons.navigate_before,
                size: 25,
              );
            }

            ButtonStyle myButtonStyle() {
              return ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    const StadiumBorder()),
                foregroundColor: MaterialStateProperty.all<Color>(activeColor),
                backgroundColor:
                MaterialStateProperty.all<Color>(inactiveColor),
              );
            }

            return IntroSlider(
              key: UniqueKey(),
              // Content config
              listContentConfig: listContentConfig,
              backgroundColorAllTabs: Colors.grey,

              // Skip button
              renderSkipBtn: renderSkipBtn(),
              skipButtonStyle: myButtonStyle(),


              // Next button
              renderNextBtn: renderNextBtn(),
              onNextPress: onNextPress,
              nextButtonStyle: myButtonStyle(),

              // Done button
              renderDoneBtn: renderDoneBtn(),
              onDonePress: onDonePress,
              doneButtonStyle: myButtonStyle(),

              // Indicator
              indicatorConfig: IndicatorConfig(
                sizeIndicator: sizeIndicator,
                indicatorWidget: Container(
                  width: sizeIndicator,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: inactiveColor),
                ),
                activeIndicatorWidget: Container(
                  width: sizeIndicator,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: activeColor),
                ),
                spaceBetweenIndicator: 10,
                typeIndicatorAnimation: TypeIndicatorAnimation.sliding,
              ),

              // Navigation bar
              navigationBarConfig: NavigationBarConfig(
                navPosition: NavPosition.bottom,
                padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .viewPadding
                      .top > 0 ? 20 : 10,
                  bottom:
                  MediaQuery
                      .of(context)
                      .viewPadding
                      .bottom > 0 ? 20 : 10,
                ),
                backgroundColor: Colors.black.withOpacity(0.5),
              ),

              // Scroll behavior
              isAutoScroll: false,
              isLoopAutoScroll: false,
              // curveScroll: Curves.bounceIn,
            );
          }

        });
  }
}
