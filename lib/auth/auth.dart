import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createAccount(String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(credentials.toString());
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      throw Exception(e);
     
    }
  }

  Future signIn(String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(credentials.toString());
    } on FirebaseAuthException catch (e) {
       log(e.message!);
      throw Exception(e);
    }
  }

  Future signOut() async {
    try {
  await _auth.signOut();
} on FirebaseAuthException catch (e) {
  log(e.message!);
      throw Exception(e);
}
  }
}
