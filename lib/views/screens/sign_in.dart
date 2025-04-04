
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:posts/utils/kTextStyle.dart';
import 'package:posts/utils/namedrouting.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Text("Sign in", style: kTextStyle(size: 40)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example123@gmail.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'xxxxxx',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                 onPressed: () async {
                  context.read<AuthProvider>().signIn(
                      context,
                      emailController.text.trim(),
                      passwordController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(400, 40),
                ),
                child: Text("Sign in"),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Dont have an account? ",
                  style: kTextStyle(size: 15, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: kTextStyle(color: Colors.blue, size: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          kNavigate(context, SignupPage());
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
