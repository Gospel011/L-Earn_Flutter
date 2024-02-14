// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:l_earn/DataLayer/Models/comment_model.dart';
import 'package:l_earn/DataLayer/Models/poll_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class Post {
  
  final User user;
  final String text;
  final String? image;
  final List<Poll>? poll;
  final int likes;
  final bool liked;
  final int comments;
  final int shares;
  final List<String> tags;
  final String id;
  final String dateCreated;

  Post({
    required this.user,
    required this.text,
    this.image,
    this.poll,
    required this.likes,
    required this.liked,
    required this.comments,
    required this.shares,
    required this.tags,
    required this.id,
    required this.dateCreated,
  });

  Post copyWith({
    User? user,
    String? text,
    String? image,
    List<Poll>? poll,
    int? likes,
    bool? liked,
    int? comments,
    int? shares,
    List<String>? tags,
    String? id,
    String? dateCreated,
  }) {
    return Post(
      user: user ?? this.user,
      text: text ?? this.text,
      image: image ?? this.image,
      poll: poll ?? this.poll,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      tags: tags ?? this.tags,
      id: id ?? this.id,
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
      'liked': liked,
      'comments': comments,
      'shares': shares,
      'tags': tags,
      '_id': id,
      'dateCreated': dateCreated,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      user: User.fromMap(map['user'] as Map<String,dynamic>),
      text: map['text'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      poll: map['poll'] != null ? List<Poll>.from((map['poll'] as List<dynamic>).map<Poll?>((x) => Poll.fromMap(x as Map<String,dynamic>),),) : null,
      likes: map['likes'] as int,
      liked: map['liked'] as bool,
      comments: map['comments'] as int,
      shares: map['shares'] as int,
      tags: List<String>.from((map['tags'] as List<dynamic>)),
      id: map['_id'] as String,
      dateCreated: map['dateCreated'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(user: $user, text: $text, image: $image, poll: $poll, likes: $likes, liked: $liked, comments: $comments, shares: $shares, tags: $tags, id: $id, dateCreated: $dateCreated)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;
  
    return 
      other.user == user &&
      other.text == text &&
      other.image == image &&
      listEquals(other.poll, poll) &&
      other.likes == likes &&
      other.liked == liked &&
      other.comments == comments &&
      other.shares == shares &&
      listEquals(other.tags, tags) &&
      other.id == id &&
      other.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return user.hashCode ^
      text.hashCode ^
      image.hashCode ^
      poll.hashCode ^
      likes.hashCode ^
      liked.hashCode ^
      comments.hashCode ^
      shares.hashCode ^
      tags.hashCode ^
      id.hashCode ^
      dateCreated.hashCode;
  }
}
