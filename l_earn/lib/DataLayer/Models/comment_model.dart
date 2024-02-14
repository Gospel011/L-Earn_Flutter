// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:l_earn/DataLayer/Models/reply_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class Comment {
  final String id;
  final User user;
  final String? articleId;
  final String? videoId;
  final String? postId;
  final List<Reply>? replies;
  final int likes;
  final bool liked;
  final String comment;
  final String dateCreated;

  const Comment(
      {required this.user,
      required this.id,
      this.articleId,
      this.videoId,
      this.postId,
      this.replies,
      required this.likes,
      required this.liked,
      required this.comment,
      required this.dateCreated});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      '_id': id,
      'articleId': articleId,
      'videoId': videoId,
      'postId': postId,
      'replies': replies?.map((x) => x.toMap()).toList(),
      'likes': likes,
      'liked': liked,
      'comment': comment,
      'dateCreated': dateCreated,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      user: User.fromMap(map['userId'] as Map<String, dynamic>),
      id: map['_id'] as String,
      articleId: map['articleId'] != null ? map['articleId'] as String : null,
      videoId: map['videoId'] != null ? map['videoId'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      replies: map['replies'] != null
          ? List<Reply>.from(
              (map['replies'] as List<dynamic>).map<Reply?>(
                (x) => Reply.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      likes: map['likes'] as int,
      liked: map['liked'] as bool,
      comment: map['comment'] as String,
      dateCreated: map['dateCreated'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(_id: $id, user: $user, articleId: $articleId, videoId: $videoId, postId: $postId, replies: $replies, likes: $likes, liked: $liked, comment: $comment, dateCreated: $dateCreated)';
  }
}
