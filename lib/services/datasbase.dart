import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iemcrp_new/models/assignmentSubmission.dart';
import 'package:iemcrp_new/models/assignments.dart';
import 'package:iemcrp_new/models/embeddings.dart';
import 'package:iemcrp_new/models/students.dart';
import 'package:iemcrp_new/models/teachers.dart';


import '../models/bill.dart';
import '../models/codes.dart';
import '../models/teachers.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference studentCollection =FirebaseFirestore.instance.collection('students');
  final CollectionReference teacherCollection =FirebaseFirestore.instance.collection('teachers');
  final CollectionReference codeCollection =FirebaseFirestore.instance.collection('codes');
  final CollectionReference assignmentCollection=FirebaseFirestore.instance.collection('assignments');
  final CollectionReference faceCollection= FirebaseFirestore.instance.collection('embeddings');
  var submissions=[];





  Future updateStudentData(String name,String enrollment_no, String stream, int year,String email,String course,String phone) async {
    return await studentCollection.doc(uid).set({
      'name': name,
      'enrollment no': enrollment_no,
      'stream' : stream,
      'year': year,
      'email': email,
      'course': course,
      'phone': phone
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
  Future updateCodeData(String code, String stream,int period,int year) async {
    return await codeCollection.doc(stream).collection(year.toString()).doc(period.toString()).set({
      'code': code,
    });
  }
  Future createAttendenceData(String stream,int period,String cdate,int year)async {
    String id="";
    studentCollection.snapshots().forEach((QuerySnapshot snapshot) async{
      var doc=snapshot.docs;
      for(var element in doc){
        if(element['stream']==stream && element['year']==year){
          await studentCollection.doc(element.id).collection('attendance').doc(cdate).set({
            period.toString():"not attended"
          },
              SetOptions(merge: true));
        }
      }
    });
  }
  Future updateAttendenceData(int period,String cdate) async {
    String p =period.toString();
    log(uid!);
    return await studentCollection.doc(uid).collection('attendance').doc(cdate).set({
      p: "attended",
    },      SetOptions(merge: true)

    );
  }
  Future updateFeesData(Bill bill) async {
    return await studentCollection.doc(uid).collection('fees').doc(bill.sem.toString()).set({
      'Id': bill.id,
      'Amount': bill.amt,
      'Date': bill.billdt,
      'Receipt': bill.url
    },      SetOptions(merge: true)

    );
  }
  Future updateAssignmentData(Assignment assignment) async{
    await assignmentCollection.doc(assignment.stream).collection('Assignment').doc(assignment.subject).set({
      'Description': assignment.desc,
      'FileUrl': assignment.fileUrl,
      'Assigned By': assignment.teacher,
      'students': [],
      'submissions': []
    });
    print(assignment.teacher);
    await teacherCollection.doc(assignment.teacher).collection('Assignments').doc(assignment.subject).set({
      'Description': assignment.desc,
      'FileUrl': assignment.fileUrl,
      'stream': FieldValue.arrayUnion([assignment.stream]),
    }
    ,SetOptions(merge: true));
    return;
  }
  Future updateAssignmentSubmissionData(AssignmentSubmission assignment) async{
    Map<dynamic,dynamic> map={
      'Description': assignment.desc,
      'FileUrl': assignment.fileUrl,
      'Name': assignment.name,
      'Stream': assignment.stream,
      'Enrollment': assignment.enrollment,
    };
    submissions.add(map);
    await assignmentCollection.doc(assignment.stream).collection('Assignment').doc(assignment.subject).update({
      'submissions': FieldValue.arrayUnion(submissions),
      'students': FieldValue.arrayUnion([assignment.id]),
      },
    );
    // assignmentCollection.doc(assignment.stream).collection('Assignment').doc(assignment.subject).get().then((DocumentSnapshot ds){
    //   teacher
    // });
  }

  Future registgerFaceEmbedding(Recognition recognition,String course,String stream,int year) async {
    await faceCollection.doc(course).collection(stream).doc(year.toString()).set({
      uid!: recognition.embeddings,
    },
        SetOptions(merge: true));

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
          course: doc.get('course') ?? '',
          phone: doc.get('phone') ?? '',

      );
    }).toList();
  }


  Stream<List<Student>> get students{
    return studentCollection.snapshots().map(_studentListFromSnapshot);
  }
   Future<Student> getStudentById(String studentId) async {
    final List<Student> allStudents = await students.first;
    final Student student = allStudents.firstWhere(
          (student) => student.id == studentId,
      orElse: () => null as Student,
    );
    return student;
  }

  Stream<List<Teacher>> get teachers{
    return teacherCollection.snapshots().map(_teacherListFromSnapshot);
  }
  Future<Teacher> getTeacherById(String teacherId) async {
    final List<Teacher> allTeachers = await teachers.first;
    final Teacher teacher = allTeachers.firstWhere(
          (teacher) => teacher.id == teacherId,
      orElse: () => null as Teacher,
    );
    return teacher;
  }

  Stream<List<Code>> get codes{
    return codeCollection.snapshots().map(_codeListFromSnapshot);
  }
  // Stream<List<Assignment>> get assignments{
  //   return assignmentCollection.snapshots(.map())
  // }




}
