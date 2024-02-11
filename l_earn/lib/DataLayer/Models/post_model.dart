// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:l_earn/DataLayer/Models/comment_model.dart';
import 'package:l_earn/DataLayer/Models/poll_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class Post {
  //* userId --> ObjectId, ref "User"
  //* text --> required
  //* image --> optional
  //* poll --> optional
  //* likes --> not user controlled, default 0
  //* comment --> ObjectId, ref "Comment"
  //* shares --> default 0,
  //* tags --> user defined, not mandatory
  //* dateCreated --> Not user defined
  final User user;
  final String text;
  final String? image;
  final List<Poll>? poll;
  final int likes;
  final List<Comment> comment;
  final int shares;
  final List<String> tags;
  final String dateCreated;

  Post({
    required this.user,
    required this.text,
    this.image,
    this.poll,
    required this.likes,
    required this.comment,
    required this.shares,
    required this.tags,
    required this.dateCreated,
  });

  Post copyWith({
    User? user,
    String? text,
    String? image,
    List<Poll>? poll,
    int? likes,
    List<Comment>? comment,
    int? shares,
    List<String>? tags,
    String? dateCreated,
  }) {
    return Post(
      user: user ?? this.user,
      text: text ?? this.text,
      image: image ?? this.image,
      poll: poll ?? this.poll,
      likes: likes ?? this.likes,
      comment: comment ?? this.comment,
      shares: shares ?? this.shares,
      tags: tags ?? this.tags,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'text': text,
      'image': image,
      'poll': poll?.map((x) => x.toMap()).toList(),
      'likes': likes,
      'comments': comment.map((x) => x.toMap()).toList(),
      'shares': shares,
      'tags': tags,
      'dateCreated': dateCreated,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    print("MAP IS = $map");
    return Post(
        user: User.fromMap(map['user'] as Map<String, dynamic>),
        text: map['text'] as String,
        image: map['image'] != null ? map['image'] as String : null,
        poll: map['poll'] != null
            ? List<Poll>.from(
                (map['poll'] as List<dynamic>).map<Poll?>(
                  (x) => Poll.fromMap(x as Map<String, dynamic>),
                ),
              )
            : null,
        likes: map['likes'] as int,
        comment: List<Comment>.from(
          (map['comments'] as List<dynamic>).map<Comment>(
            (x) => Comment.fromMap(x as Map<String, dynamic>),
          ),
        ),
        shares: map['shares'] as int,
        tags: List<String>.from((map['tags'] as List<dynamic>)),
        dateCreated: map['dateCreated']);
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(user: $user, text: $text, image: $image, poll: $poll, likes: $likes, comment: $comment, shares: $shares, tags: $tags, dateCreated: $dateCreated)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.user == user &&
        other.text == text &&
        other.image == image &&
        listEquals(other.poll, poll) &&
        other.likes == likes &&
        listEquals(other.comment, comment) &&
        other.shares == shares &&
        listEquals(other.tags, tags) &&
        other.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        text.hashCode ^
        image.hashCode ^
        poll.hashCode ^
        likes.hashCode ^
        comment.hashCode ^
        shares.hashCode ^
        tags.hashCode ^
        dateCreated.hashCode;
  }
}
