import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
//we set authorisation as an abstract class in order to eventually adapt it
//to other set ups
abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> isEmailVerified();
}