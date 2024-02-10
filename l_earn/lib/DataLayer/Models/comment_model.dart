// ignore_for_file: public_member_api_docs, sort_constructors_first
// userId
// articleId
// videoId
// postId
// replies
// likes
// comment
// dateCreated

import 'dart:convert';

import 'package:l_earn/DataLayer/Models/reply_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class Comment {
  final User user;
  final String? articleId;
  final String? videoId;
  final String? postId;
  final Reply? replies;
  final int likes;
  final String comment;
  final DateTime dateCreated;

  const Comment(
      {required this.user,
      this.articleId,
      this.videoId,
      this.postId,
      this.replies,
      required this.likes,
      required this.comment,
      required this.dateCreated});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'articleId': articleId,
      'videoId': videoId,
      'postId': postId,
      'replies': replies?.toMap(),
      'likes': likes,
      'comment': comment,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      user: User.fromMap(map['user'] as Map<String,dynamic>),
      articleId: map['articleId'] != null ? map['articleId'] as String : null,
      videoId: map['videoId'] != null ? map['videoId'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      replies: map['replies'] != null ? Reply.fromMap(map['replies'] as Map<String,dynamic>) : null,
      likes: map['likes'] as int,
      comment: map['comment'] as String,
      dateCreated: DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source) as Map<String, dynamic>);
}
