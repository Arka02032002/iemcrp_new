import 'dart:developer';
import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iemcrp_new/models/assignments.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iemcrp_new/services/datasbase.dart';
import '../../shared/constants.dart';


class Assignment_stream extends StatefulWidget {

  @override
  State<Assignment_stream> createState() => _Assignment_streamState();
}

class _Assignment_streamState extends State<Assignment_stream> {

  String desc="";
  String stream=Get.arguments[1];
  String subject="";
  String fileurl="";
  // String stream="";
  String filename="";
  String uploadingStatus="";
  String submissionStatus="";
  String teacher=Get.arguments[0];
  bool isselected=false;
  String buttonText="Browse";
  int year=0;

  PlatformFile? pickedFile;
  DatabaseService db =new DatabaseService();
  Future browseFile()async{
    if(isselected)
      uploadFile();
    else {
      final result = await FilePicker.platform.pickFiles();
      if (result == null)
        return;
      setState(() {
        isselected=true;
        buttonText='Upload';
        pickedFile = result.files.single;
        filename = pickedFile!.name;
      });
    }
  }
  Future uploadFile()async{
    setState(() {
      uploadingStatus="Uploading...";
    });
    final path='assignments/${pickedFile?.name}';
    final File file=File(pickedFile!.path!);
    final ref= FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    fileurl=await ref.getDownloadURL();
    setState(() {
      uploadingStatus="Uploaded $filename";
    });
    log(stream);
    log(desc);
    log(fileurl);
  }
  Future submitAssignment() async{
    log(stream);
    log(desc);
    log(fileurl);
    Assignment assignment= await new Assignment(desc: desc, subject: subject, teacher: teacher, stream: stream,fileUrl: fileurl,year: year);
    await db.updateAssignmentData(assignment);
    setState(() {
      submissionStatus="Assignment Submitted";
    });

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
                decoration: textInputDecoration.copyWith(hintText: 'Year'),
                onChanged: (val){
                  setState(() {
                    year=int.parse(val);
                  });
                },
              ),
              SizedBox(height: 10,),

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
              SizedBox(height: 20,),
              Row(children: [
                SizedBox(
                  width: 300,
                  height: 35,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(filename),
                    ),
                    color: Colors.grey[200],
                    borderOnForeground: false,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
                ElevatedButton(onPressed: browseFile, child: Text(buttonText)),
              ],),
              SizedBox(height: 3,),
              Text(uploadingStatus),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: submitAssignment, child: Text("Submit")),
              SizedBox(height: 3,),
              Text(submissionStatus),
            ],

          ),
        ),

      ),
    );
  }
}
