import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String? email;
  String? username;
  String? id;
  User({
    this.email,
    this.username,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'id': id,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? email,
    String? username,
    String? id,
  }) {
    return User(
      email: email ?? this.email,
      username: username ?? this.username,
      id: id ?? this.id,
    );
  }
}
