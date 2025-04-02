import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:posts/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:posts/providers/auth_provider.dart';
import 'package:posts/views/screens/signup.dart';
import 'package:provider/provider.dart';

import 'views/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data != null) {
              return MyHomePage();
            }
            return SignupPage();
          }),
    ),
    );
  }
}
