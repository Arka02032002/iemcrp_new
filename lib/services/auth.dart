import 'package:firebase_auth/firebase_auth.dart';
import 'package:iemcrp_new/models/user.dart';

class AuthService{

  //instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //user object based on firebase user
  IemcrpUser? _userFromFirebaseUser (User user){
    return user!=null ? IemcrpUser(uid: user.uid, email: user.email):null;

  }

  //auth change user stream
  Stream<IemcrpUser> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!)!);
    // .map(_userfromFirebaseUser);
  }



  //sign in anonymously
  Future signInAnom() async{
  try{
    UserCredential result = await _auth.signInAnonymously();
    User? user= result.user;
    return _userFromFirebaseUser(user!);
  }
  catch(e){
    print(e.toString());
    return null;
  }
  }


  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // print('USER');
      // print(user);
      return _userFromFirebaseUser(user!);
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