import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/authentication.dart';

//implementation of BaseAuth with all it's methods, all dealing with FirebaseAuth API
class AuthService implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  } 
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser result = await _firebaseAuth.currentUser();
    return result;
  }

  Future<void> signOut() async {
    print('Signed Out');
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}