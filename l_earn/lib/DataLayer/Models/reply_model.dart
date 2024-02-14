// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:l_earn/DataLayer/Models/user_model.dart';

class Reply {
  final User user;
  final String? commentId;
  final int likes;
  final String reply;
  final DateTime dateCreated;

  const Reply(
      {required this.user,
      this.commentId,
      required this.likes,
      required this.reply,
      required this.dateCreated});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'commentId': commentId,
      'likes': likes,
      'reply': reply,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      user: User.fromMap(map['user'] as Map<String,dynamic>),
      commentId: map['commentId'] != null ? map['commentId'] as String : null,
      likes: map['likes'] as int,
      reply: map['reply'] as String,
      dateCreated: DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Reply.fromJson(String source) => Reply.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Reply(user: $user, commentId: $commentId, likes: $likes, reply: $reply, dateCreated: $dateCreated)';
  }
}
