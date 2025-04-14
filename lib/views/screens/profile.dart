// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:posts/auth/auth.dart';
import 'package:posts/models/post.dart';
import 'package:posts/providers/auth_provider.dart';
import 'package:posts/utils/kTextStyle.dart';
import 'package:posts/views/widgets/post_tile.dart';
import 'package:provider/provider.dart';
import 'package:posts/auth/database.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({
    Key? key,
    required this.username,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService auth = AuthService();
  DatabaseServices database = DatabaseServices();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 221, 221, 221),
        appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 221, 221, 221)),
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
              List<Post> filterData = data
                  .where((item) => item.id == FirebaseAuth.instance.currentUser!.uid)
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.deepOrangeAccent,
                      child: Text(widget.username[0].toUpperCase(),
                          style: kTextStyle(size: 30)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      widget.username,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text(
                      "Posts made by me (${filterData.length})",
                      style: kTextStyle(size: 20),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      itemCount: filterData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: PostTile(
                            avatar: Text(
                              widget.username[0],
                              style: kTextStyle(size: 12),
                            ),
                            displayName: widget.username,
                            title: filterData[index].title,
                            content: filterData[index].body,
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: FilledButton(
                      onPressed: () => showConfirmDialog(context),
                      child: Text("Sign Out"),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}

void showConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Are you sure?",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text("Are You sure you want to log out?"),
        actionsPadding: EdgeInsets.only(bottom: 16, right: 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("No"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthProvider>().signOut(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Yes"),
              ),
            ],
          )
        ],
      );
    },
  );
}
