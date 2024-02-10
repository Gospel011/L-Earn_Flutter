// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppError {
  final String title;
  final String content;
  const AppError({required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
    };
  }

  factory AppError.fromMap(Map<String, dynamic> map) {
    return AppError(
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppError.fromJson(String source) => AppError.fromMap(json.decode(source) as Map<String, dynamic>);
}
