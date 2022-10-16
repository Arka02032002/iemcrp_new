import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iemcrp_new/models/students.dart';
import 'package:iemcrp_new/models/teachers.dart';

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

  // brew list from snapshot
  List<Teacher> _teacherListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return Teacher(
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
          name: doc.get('name') ?? '',
          enrollment: doc.get('enrollment no') ?? '',
          stream: doc.get('stream') ?? '',
          year: doc.get('year') ?? 0
      );
    }).toList();
  }

  Stream<List<Student>> get students{
    return studentCollection.snapshots().map(_studentListFromSnapshot);
  }
  Stream<List<Teacher>> get teachers{
    return teacherCollection.snapshots().map(_teacherListFromSnapshot);
  }



}
