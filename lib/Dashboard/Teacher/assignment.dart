import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iemcrp_new/services/code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iemcrp_new/services/datasbase.dart';
import '../../shared/constants.dart';


class Assignment_stream extends StatefulWidget {

  @override
  State<Assignment_stream> createState() => _Assignment_streamState();
}

class _Assignment_streamState extends State<Assignment_stream> {

  String desc="";
  String stream="";
  String subject="";
  String fileurl="";
  String filename="";
  PlatformFile? pickedFile;
  DatabaseService db =new DatabaseService();
  Future browseFile()async{
    final result = await FilePicker.platform.pickFiles();
    if(result==null)
      return;
    setState(() {
      pickedFile=result.files.single;
      filename=pickedFile!.name;
    });
  }
  Future uploadFile()async{
    final path='assignments/${pickedFile?.name}';
    final File file=File(pickedFile!.path!);
    final ref= FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    fileurl=await ref.getDownloadURL();
    log(stream);
    log(desc);
    log(fileurl);
  }
  Future submitAssignment() async{
    db.updateAssignmentData(stream,desc,subject,fileurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("Create Assignment"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Stream'),
                onChanged: (val){
                  setState(() {
                    stream=val;
                  });
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Subject'),
                onChanged: (val){
                  setState(() {
                    subject=val;
                  });
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Assignment description'),
                onChanged: (val){
                  setState(() {
                  desc=val;
                  });
                },
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: browseFile, child: Text("Browse")),
              SizedBox(height: 10,),
              Text('Attached File: '+filename),
              SizedBox(height: 5,),
              ElevatedButton(onPressed: uploadFile, child: Text("Upload")),
              SizedBox(height: 15,),
              ElevatedButton(onPressed: submitAssignment, child: Text("Submit")),




            ],

          ),
        ),

      ),
    );
  }
}
