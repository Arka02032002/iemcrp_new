import 'dart:convert';
import 'dart:math';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iemcrp_new/services/datasbase.dart';
import 'package:iemcrp_new/services/receipt.dart';
import '../../models/bill.dart';
import '../loading.dart';

class FeesDashboard extends StatefulWidget {


  @override
  State<FeesDashboard> createState() => _FeesDashboardState();
}

class _FeesDashboardState extends State<FeesDashboard> {
  String course = Get.arguments[0];
  String email=Get.arguments[1];
  String phone=Get.arguments[2];
  String id=Get.arguments[3];
  String name=Get.arguments[4];
  String enrollment=Get.arguments[5];
  String stream=Get.arguments[6];
  int year=Get.arguments[7];
  int fees = 0, sems = 0;
  String paymentDescription='';



  @override
  Widget build(BuildContext context) {
    print(course+ ' '+ sems.toString());
    List<int> semPaid=[];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Fees Payment"),
      ),
      body: Container(
        child:
        StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('fees')
              .doc(course).snapshots(),
          builder: (context, snapshot1) {
            if(!snapshot1.hasData)
              return Loading();
            else {
              fees=snapshot1.data?['fees'];
              sems=snapshot1.data?['sems'];
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('students').doc(id).collection('fees').snapshots(),
                builder: (context, snapshot2) {
                  if(!snapshot2.hasData)
                  return Loading();
                  else {
                    for(var element in snapshot2.data!.docs){
                      semPaid.add(int.parse(element.id));
                    }
                    print(semPaid);
                    return Column(
                      children: [
                        for (int i = 0; i < sems; i++)
                          if(!semPaid.contains(i+1))
                          Card(
                            margin: EdgeInsets.all(8),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Semester " + (i + 1).toString(),style: TextStyle(fontSize: 18),),
                                    SizedBox(width: 60,),
                                    Text('₹ '+fees.toString(),style: TextStyle(fontSize: 18),),
                                    SizedBox(width: 70,),
                                    ElevatedButton(
                                      onPressed: (){payClickHandle(i+1);}, child: Text("Pay",style: TextStyle(fontSize: 18),),)
                                  ],
                                ),
                              )
                          )
                      ]);}
                }
              );
            }
          }
        ),
      ),
    );
  }

  void payClickHandle(int sem) {
    int orderId = Random().nextInt(1000);

    num payableAmount = num.parse(fees.toString());
    getAccessToken(payableAmount, orderId).then((tokenData) {
      Map<String, String> _params = {
        'stage': 'TEST',
        'orderAmount': fees.toString(),
        'orderId': '$orderId',
        'orderCurrency': 'INR',
        'customerPhone': phone,
        'customerEmail': email,
        'tokenData': tokenData,
        'appId': 'TEST1002889417041e66c2b7ea48acdb49882001',
      };
      CashfreePGSDK.doPayment(_params).then((value) async{
        print(value);
        print(id);
        DatabaseService db=await new DatabaseService(uid: id);
        ReceiptServices rp=await new ReceiptServices();
        if (value != null) {
          if (value['txStatus'] == 'SUCCESS') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment Success"),
              ),
            );
            final receipt= await rp.createBillReceipt(name,course,stream,enrollment,sem,year,fees);
            String url =await rp.saveBill("Semester_$sem", receipt);
            Bill bill=await new Bill(id: orderId, sem: sem, amt: fees, billdt: value['txTime'],url: url);
            await db.updateFeesData(bill);

          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment Failed"),
              ),
            );
          }
        }
      });
    });
  }

  Future<String> getAccessToken(num amount, num orderId) async {
    var res = await http.post(
      Uri.https("test.cashfree.com", "api/v2/cftoken/order"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-client-id': "TEST1002889417041e66c2b7ea48acdb49882001",
        'x-client-secret': "TESTaf58cf33926c6f1552c846cb76cc165741a0e79e",
      },
      body: jsonEncode(
        {
          "orderId": '$orderId',
          "orderAmount": amount,
          "orderCurrency": "INR",
        },
      ),
    );
    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      if (jsonResponse['status'] == 'OK') {
        return jsonResponse['cftoken'];
      }
    }
    return '';
  }
}
