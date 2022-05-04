import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_ing_validator/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // used to interact with firebase auth

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}