import 'package:cloud_firestore/cloud_firestore.dart';
class Post {
  String? id;
  String? title;
  String? body;
  DateTime? createdAt;
  Post(
      {required this.title,
      required this.body,
      required this.id,
      required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: (json['createdTime'] as Timestamp).toDate(),
    );
  }
}
