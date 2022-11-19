import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iemcrp_new/models/user.dart';
import 'package:iemcrp_new/services/datasbase.dart';


class AuthService{

  //instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //user object based on firebase user
  IemcrpUser? _userFromFirebaseUser (User? user){
    return user!=null ? IemcrpUser(uid: user.uid, email: user.email ,creationdt: user.metadata.creationTime,lastsignindt: user.metadata.lastSignInTime):null;

  }

  //auth change user stream
  Stream<IemcrpUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!)!);
    // .map(_userfromFirebaseUser);
  }



  //sign in anonymously
  // Future signInAnom() async{
  // try{
  //   UserCredential result = await _auth.signInAnonymously();
  //   User? user= result.user;
  //   return _userFromFirebaseUser(user!);
  // }
  // catch(e){
  //   print(e.toString());
  //   return null;
  // }
  // }


  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print("METADATA");
      print(user?.providerData);
      bool data= result.additionalUserInfo!.isNewUser;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name, String stream, String enrollment,int salary, int year) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      bool data= result.additionalUserInfo!.isNewUser;
      print(data);
      User? user = result.user;



      //create a new document for th user with thr uid

      if (email.contains("iemcal")) {
        FirebaseFirestore.instance.collection('students').doc(user?.uid).collection('Attendence Record');
        await DatabaseService(uid: user?.uid)
            .updateTeacherData(name, email, stream, salary);
      }
      else{
        await DatabaseService(uid: user?.uid)
            .updateStudentData(name,enrollment,stream,year,email);
        // await DatabaseService(uid: user?.uid).createAttendanceData()
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }



  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString);
      return null;
    }
  }
}