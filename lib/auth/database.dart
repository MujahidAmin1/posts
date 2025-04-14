import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:posts/models/post.dart';

import '../models/user.dart';

typedef FutureVoid = Future<void>;

final FirebaseAuth _auth = FirebaseAuth.instance;

class DatabaseServices {
  FutureVoid createUser(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.id)
          .set(user.toMap());
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<User?> fetchUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return User.fromMap(doc.data()!);
  }

  Future createPost(Post post) async {
    final mypost = FirebaseFirestore.instance.collection("posts").doc();
    await mypost.set(post.toJson());
  }

  final currentUser = _auth.currentUser;
  Stream<List<Post>> readPosts() {
    try {
      if (currentUser == null) {
        return Stream.value([]);
      }

      final posts = FirebaseFirestore.instance.collection("posts");

      return posts.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
    } on Exception catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future updatePost(Post post, String title, String body, String uid) async {
    final updatedPost = post.copyWith(
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
    final posts =
        FirebaseFirestore.instance.collection('posts').doc(updatedPost.id);
    await posts.update(updatedPost.toJson());
  }

  Future deletePost(Post post, String uid) async {
    final posts = FirebaseFirestore.instance.collection(uid).doc(post.id);
    await posts.delete();
  }
}
