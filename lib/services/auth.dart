import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_ing_validator/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // used to interact with firebase auth

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("error, happened");
      print(e.toString());
      return null;
    }
  }

  //sign up

  Future SignUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch (error) {
      print("this is an error");
      dynamic result = {
        "error" : true,
        "message" : error.toString()
      };
      return result;
    }
  }

  //sing in
  Future SignInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch (error) {
      dynamic result = {
        "error" : true,
        "message" : error.toString()
      };
      print(error.toString());
      return result;
    }
  }

  // Sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }


}