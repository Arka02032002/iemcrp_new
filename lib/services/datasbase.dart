import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iemcrp_new/models/questions.dart';
import 'package:iemcrp_new/models/students.dart';
import 'package:iemcrp_new/models/teachers.dart';
import 'package:iemcrp_new/services/code.dart';

import '../models/codes.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference studentCollection =FirebaseFirestore.instance.collection('students');
  final CollectionReference teacherCollection =FirebaseFirestore.instance.collection('teachers');
  final CollectionReference questionCollection =FirebaseFirestore.instance.collection('questions');
  final CollectionReference codeCollection =FirebaseFirestore.instance.collection('codes');
  // final CollectionReference Attendencecollection =FirebaseFirestore.instance.collection('students');



  Future updateStudentData(String name,String enrollment_no, String stream, int year,String email) async {
    return await studentCollection.doc(uid).set({
      'name': name,
      'enrollment no': enrollment_no,
      'stream' : stream,
      'year': year,
      'email': email,
    });
  }
  Future updateTeacherData(String name,String? email, String stream, int salary) async {
    return await teacherCollection.doc(uid).set({
      'name': name,
      'email': email,
      'stream' : stream,
      'salary': salary,
    });
  }
  Future updateCodeData(String code, String stream,int period) async {
    return await codeCollection.doc(stream).set({
      'code': code,
      'period': period,
    });
  }
  Future updateAttendenceData(int period,String cdate) async {
    String p =period.toString();
    log(uid!);
    return await studentCollection.doc(uid).collection('attendance').doc(cdate).set({
      p: true,
    },      SetOptions(merge: true)

    );
  }

  List<Code> _codeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return Code(
          code: doc.get('code') ?? '',
          stream: doc.get('stream') ?? '',



      );
    }).toList();
  }

  // brew list from snapshot
  List<Teacher> _teacherListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return Teacher(
          id: doc.id,
          name: doc.get('name') ?? '',
          email: doc.get('email') ?? '',
          stream: doc.get('stream') ?? '',
          salary: doc.get('salary') ?? 0
      );
    }).toList();
  }

  List<Student> _studentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return Student(
          id: doc.id,
          name: doc.get('name') ?? '',
          enrollment: doc.get('enrollment no') ?? '',
          stream: doc.get('stream') ?? '',
          year: doc.get('year') ?? 0,
          email: doc.get('email') ?? '',

      );
    }).toList();
  }

  List<Question> _questionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return Question(
          id: doc.get('id') ?? '',
          question: doc.get('question') ?? '',
          options: doc.get('options') ?? '',
          answer: doc.get('ans') ?? 0
      );
    }).toList();
  }

  Stream<List<Student>> get students{
    return studentCollection.snapshots().map(_studentListFromSnapshot);
  }
  Stream<List<Teacher>> get teachers{
    return teacherCollection.snapshots().map(_teacherListFromSnapshot);
  }
  Stream<List<Question>> get questions{
    final CollectionReference dbmsCollection =questionCollection.doc('DBMS').collection('Intro');
    return dbmsCollection.snapshots().map(_questionListFromSnapshot);
    // return questionCollection.doc('DBMS').collection('Intro').doc('q1');
  }
  Stream<List<Code>> get codes{
    return codeCollection.snapshots().map(_codeListFromSnapshot);
  }




}
