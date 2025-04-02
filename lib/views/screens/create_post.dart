import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:posts/auth/database.dart';
import 'package:posts/models/post.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseServices data = DatabaseServices();
  late TextEditingController titleController;
  late TextEditingController bodyController;
  @override
  void initState() {
    titleController = TextEditingController();
    bodyController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(
                hintText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                try {
                  var post = Post(
                    title: titleController.text,
                    body: bodyController.text,
                    id: _auth.currentUser!.uid,
                    postId: null,
                    createdAt: DateTime.now(),
                  );
                  data.createPost(post);
                  Navigator.pop(context);
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(400, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
