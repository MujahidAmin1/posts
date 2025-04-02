import 'package:firebase_auth/firebase_auth.dart' hide User, AuthProvider;
import 'package:flutter/material.dart';
import 'package:posts/auth/auth.dart';
import 'package:posts/auth/database.dart';
import 'package:posts/models/user.dart';
import 'package:posts/views/screens/home.dart';
import 'package:posts/views/screens/signup.dart';

class AuthProvider extends ChangeNotifier {
  AuthService authService = AuthService();
  DatabaseServices databaseServices = DatabaseServices();
  bool isLoading = false;
  Future signOut(BuildContext context) async {
    try {
      await authService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignupPage();
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void signIn(BuildContext context, String email, String password) async {
    isLoading = true;
    try {
      await authService.signIn(email, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MyHomePage();
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    isLoading = false;
  }

  Stream<String> fetchUsername() {
    var userData = databaseServices.fetchUser();
    return userData.map((user) => user.username ?? "User");
  }

  void createAcct(BuildContext context, String username, String email,
      String password) async {
    isLoading = true;
    try {
      await authService.createAccount(email, password);
      await authService.signIn(email, password);
      await databaseServices.createUser(User(
          email: email,
          username: username,
          id: FirebaseAuth.instance.currentUser!.uid));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MyHomePage();
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    isLoading = false;
  }
}
