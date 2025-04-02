import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class Post {
  String? postId;
  String? id;
  String? title;
  String? body;
  DateTime? createdAt;

  static const Uuid _uuid = Uuid();
  Post({
    String? postId,
    required this.title,
    required this.body,
    required this.id,
    required this.createdAt,
  }) : postId = postId ?? _uuid.v4();
  Post copyWith({
    String? postId,
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
  }) {
    return Post(
      postId: postId ?? this.postId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'] as String,
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
