import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:posts/auth/database.dart';
import 'package:posts/providers/auth_provider.dart';
import 'package:posts/utils/namedrouting.dart';
import 'package:posts/views/screens/create_post.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseServices database = DatabaseServices();
  AuthProvider authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: context
              .watch<AuthProvider>()
              .fetchUsername(), // Fetching username stream from AuthProvider
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading while fetching
            }

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}"); // Error handling
            }

            String username = snapshot.data ??
                "User"; // Default to "User" if no username found
            return Text(username); // Display the username in the title
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await context
                  .read<AuthProvider>()
                  .signOut(context); // Log out functionality
            },
            child: const Text("Logout"),
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: database.readPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          List<Post> data = snapshot.data!;
          List<Post> filterData =
              data.where((item) => item.id == auth.currentUser!.uid).toList();
          return ListView.builder(
              itemCount: filterData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filterData[index].title!),
                  subtitle: Text(filterData[index].body!),
                  trailing: Text(filterData[index].createdAt.toString()),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        kNavigate(context, CreatePost());
      }),
    );
  }
}
