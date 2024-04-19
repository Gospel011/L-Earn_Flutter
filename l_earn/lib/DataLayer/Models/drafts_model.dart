import 'dart:convert';
import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Drafts extends Equatable {
  final String id;
  final String? bookName;
  final int? chapter;
  final String title;
  final List<Map<String, dynamic>> content;
  final DateTime dateLastUpdated;

  const Drafts({
    required this.id,
    required this.bookName,
    required this.chapter,
    this.title = 'untitled',
    required this.content,
    required this.dateLastUpdated,
  });

  @override
  List<Object> get props => [id];

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
      bookName: map['bookName'] != null ? map['bookName'] as String : null,
      chapter: map['chapter'] != null ? map['chapter'] as int : null,
      title: map['title'] as String,
      content: List<Map<String, dynamic>>.from(
        (map['content'] as List<Map<String, dynamic>>)
            .map<Map<String, dynamic>>(
          (x) => x,
        ),
      ),
      dateLastUpdated:
          DateTime.fromMillisecondsSinceEpoch(map['dateLastUpdated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Drafts.fromJson(String source) =>
      Drafts.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Drafts(id: $id, bookName: $bookName, chapter: $chapter, title: $title, content: $content, dateLastUpdated: $dateLastUpdated)';
  }
}
