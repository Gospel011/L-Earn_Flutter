// ignore_for_file: public_member_api_docs, sort_constructors_first
// contentId:
// chapter:
// title:
// content:
// comments:
// tags:
// dateCreated:
// id:
// author:

import 'dart:convert';

import 'package:l_earn/DataLayer/Models/comment_model.dart';


class Article {
final String id;
final int chapter;
final String title;
final String? contentId;
final String? content;
final List<Comment>? comments;
final List<String>? tags;
final String? dateCreated;
  Article({
    required this.id,
    required this.chapter,
    required this.title,
    this.contentId,
    this.content,
    this.comments,
    this.tags,
    this.dateCreated,
  });
// final User? author;
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'chapter': chapter,
      'title': title,
      'contentId': contentId,
      'content': content,
      'comments': comments?.map((x) => x.toMap()).toList(),
      'tags': tags,
      'dateCreated': dateCreated,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['_id'] as String,
      chapter: map['chapter'] as int,
      title: map['title'] as String,
      contentId: map['contentId'] != null ? map['contentId'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      comments: map['comments'] != null ? List<Comment>.from((map['comments'] as List<dynamic>).map<Comment?>((x) => Comment.fromMap(x as Map<String,dynamic>),),) : null,
      tags: map['tags'] != null ? List<String>.from((map['tags'] as List<dynamic>)) : null,
      dateCreated: map['dateCreated'] != null ? map['dateCreated'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) => Article.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Article(id: $id, chapter: $chapter, title: $title, contentId: $contentId, content: $content, comments: $comments, tags: $tags, dateCreated: $dateCreated)';
  }
}
