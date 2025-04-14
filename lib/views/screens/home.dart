import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:posts/auth/database.dart';
import 'package:posts/providers/auth_provider.dart';
import 'package:posts/utils/kTextStyle.dart';
import 'package:posts/utils/namedrouting.dart';
import 'package:posts/views/screens/create_post.dart';
import 'package:posts/views/screens/profile.dart';
import 'package:posts/views/widgets/post_tile.dart';

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
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 221, 221, 221),
        title: Text("Posts"),
        actions: [
          FutureBuilder(
            future: database.fetchUser(auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final user = snapshot.data;
              return GestureDetector(
                onTap: () {
                  kNavigate(
                    context,
                    ProfilePage(
                      username: user.username!,
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 239, 102, 60),
                  radius: 15,
                  child: Text(
                    user!.username!.substring(0, 1), // Accessing username here
                    style: kTextStyle(
                      size: 20,
                      isBold: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: database.readPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
            itemCount: data.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: database.fetchUser(data[index].id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  final user = snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: PostTile(
                      avatar: Text(
                        user!.username!.substring(0, 1).toUpperCase(),
                        style: kTextStyle(size: 12),
                      ),
                      displayName: user.username,
                      title: data[index].title,
                      content: data[index].body,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          kNavigate(context, CreatePost());
        },
      ),
    );
  }
}
