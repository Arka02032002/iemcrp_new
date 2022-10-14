import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference studentCollection =FirebaseFirestore.instance.collection('students');
  final CollectionReference teacherCollection =FirebaseFirestore.instance.collection('teachers');


  Future updateStudentData(String name,String enrollment_no, String stream, int year) async {
    return await studentCollection.doc(uid).set({
      'name': name,
      'enrollment no': enrollment_no,
      'stream' : stream,
      'year': year,
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

  Stream<QuerySnapshot> get students{
    return studentCollection.snapshots();
  }
  Stream<QuerySnapshot> get teachers{
    return studentCollection.snapshots();
  }



}
