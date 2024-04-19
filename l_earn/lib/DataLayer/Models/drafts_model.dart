import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:l_earn/utils/constants.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Drafts {
  final String id;
  final String bookName;
  final int chapter;
  final String title;
  final Map<String, String> content;
  final DateTime dateLastUpdated;

  Drafts({
    required this.id,
    required this.bookName,
    required this.chapter,
    required this.title,
    required this.content,
    required this.dateLastUpdated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookName': bookName,
      'chapter': chapter,
      'title': title,
      'content': content,
      'dateLastUpdated': dateLastUpdated.millisecondsSinceEpoch,
    };
  }

  factory Drafts.fromMap(Map<String, dynamic> map) {
    return Drafts(
      id: map['id'] as String,
      bookName: map['bookName'] as String,
      chapter: map['chapter'] as int,
      title: map['title'] as String,
      content: Map<String, String>.from((map['content'] as Map<String, String>)),
      dateLastUpdated: DateTime.fromMillisecondsSinceEpoch(map['dateLastUpdated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Drafts.fromJson(String source) =>
      Drafts.fromMap(json.decode(source) as Map<String, dynamic>);

  Drafts copyWith({
    String? id,
    String? bookName,
    int? chapter,
    String? title,
    Map<String, String>? content,
    DateTime? dateLastUpdated,
  }) {
    return Drafts(
      id: id ?? this.id,
      bookName: bookName ?? this.bookName,
      chapter: chapter ?? this.chapter,
      title: title ?? this.title,
      content: content ?? this.content,
      dateLastUpdated: dateLastUpdated ?? this.dateLastUpdated,
    );
  }

  @override
  String toString() {
    return 'Drafts(id: $id, bookName: $bookName, chapter: $chapter, title: $title, content: $content, dateLastUpdated: $dateLastUpdated)';
  }

  
}
