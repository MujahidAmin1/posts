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
      appBar: AppBar(
        title: Text('Create Post'),
      ),
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
            const SizedBox(height: 15),
            TextField(
              controller: bodyController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
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
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(410, 45),
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
