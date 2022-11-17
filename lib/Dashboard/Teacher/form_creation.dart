import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iemcrp_new/services/code.dart';
import 'package:uuid/uuid.dart';

import '../../shared/constants.dart';

class Question_fromDatabase extends StatefulWidget {
  // get code => null;



  @override


  State<Question_fromDatabase> createState() => _Question_fromDatabaseState();
}

class _Question_fromDatabaseState extends State<Question_fromDatabase> {

  String code="Code";
  String stream="";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Attendence"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),

              Text("Attendence Code",
                style: TextStyle(
                    fontSize: 23
                ),),
              SizedBox(height: 10,),

              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Enter Stream'),
                onChanged: (val){
                  setState(() {
                    stream=val;
                  });

                },

              ),

              SizedBox(height: 10,),

              SizedBox(height: 10,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(code,
                        maxLines: 2,
                        softWrap: false,
                        style: TextStyle(
                          overflow: TextOverflow.fade,
                          fontSize: 18
                        ),),
                      ),
                      SizedBox(width: 10,),
                      IconButton(onPressed: ()async{
                        await Clipboard.setData(ClipboardData(text:code));
                      },
                          icon: Icon(Icons.copy,),
                      )
                    ],
                  ),
                ),

              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: ()async {
                final Attendence_Code ac= new Attendence_Code(stream: stream);
                var temp_code=await ac.generateCode();
                print("------------");
                log(temp_code);
                setState(() {
                  code=temp_code;

                });
              },
                  child: Text("Generate Code",
                    style: TextStyle(
                        fontSize: 20
                    ),))
            ],
          ),
        ),

      ),

    );
  }
}
