// ignore_for_file: public_member_api_docs, sort_constructors_first
// authorId:
// contentId:
// chapter:
// url:
// title:
// description:
// comments:.
// tags:.......
// dateCreated:.........
// Id.......

import 'dart:convert';

import 'package:l_earn/DataLayer/Models/comment_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class Video {
  final String id;
  final int chapter;
  final String title;
  final String? contentId;
  final String? content;
  final String? description;
  final List<Comment>? comments;
  final List<String>? tags;
  final String? dateCreated;
  Video({
    required this.id,
    required this.chapter,
    required this.title,
    this.contentId,
    this.content,
    this.description,
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
      'description': description,
      'comments': comments?.map((x) => x.toMap()).toList(),
      'tags': tags,
      'dateCreated': dateCreated,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['_id'] as String,
      chapter: map['chapter'] as int,
      title: map['title'] as String,
      contentId: map['contentId'] != null ? map['contentId'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      comments: map['comments'] != null ? List<Comment>.from((map['comments'] as List<int>).map<Comment?>((x) => Comment.fromMap(x as Map<String,dynamic>),),) : null,
      tags: map['tags'] != null ? List<String>.from((map['tags'] as List<String>)) : null,
      dateCreated: map['dateCreated'] != null ? map['dateCreated'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Video(id: $id, chapter: $chapter, title: $title, contentId: $contentId, content: $content, description: $description, comments: $comments, tags: $tags, dateCreated: $dateCreated)';
  }
}
