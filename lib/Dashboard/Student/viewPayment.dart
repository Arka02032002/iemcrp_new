import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:iemcrp_new/Dashboard/loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'noti.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class ViewPayments extends StatefulWidget {
  @override
  State<ViewPayments> createState() => _ViewPaymentsState();
}

class _ViewPaymentsState extends State<ViewPayments> {
  String id = Get.arguments;

  @override
  void initState(){
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }
  Widget build(BuildContext context) {
    print(id);
    log(id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Data"),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(id)
            .collection('fees')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Loading();
          else if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "No data found 😥",
              style: TextStyle(
                fontSize: 18,
              ),
            ));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (var element in snapshot.data!.docs)
                    Card(
                      elevation: 6,
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Semester ${element.id}",style: TextStyle(fontSize: 18),),
                                SizedBox(width: 150),
                                Text("Bill Id: ${element['Id']}",style: TextStyle(fontSize: 18),)
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("₹ ${element['Amount']}",style: TextStyle(fontSize: 18),),
                              ],
                            ),
                            SizedBox(height: 20),

                            Text("${element['Date']}",style: TextStyle(fontSize: 18),),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(onPressed: () async {
                                  var time= DateTime.now().millisecondsSinceEpoch;
                                  var path="/storage/emulated/0/Download/receipt-${time}_Semester-${element.id}.pdf";
                                  var file=File(path);
                                  var res= await get(Uri.parse(element['Receipt']));
                                  file.writeAsBytes(res.bodyBytes);
                                  Noti.showBigTextNotification(title: "Download Complete", body: "receipt-${time}_Semester-${element.id}", fln: flutterLocalNotificationsPlugin,payload: res.body);
                                }, child:
                                Row(children: [
                                  Icon(Icons.file_download_outlined),
                                  SizedBox(width: 10,),
                                  Text("Download Receipt")
                                ],))
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        },
      )),
    );
  }
}
