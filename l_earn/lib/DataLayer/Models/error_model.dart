// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

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

  static AppError errorObject(response) {
    return AppError(
        title: response["title"] ?? 'Error', content: response["message"]);
  }

  factory AppError.fromMap(Map<String, dynamic> map) {
    return AppError(
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }

  static Map<String, String> handleError(Object e) {
    if (e is http.ClientException) {
      String errno = "$e".split('errno = ')[1].split('),')[0];
      print("E R R O R NUMBER IS $errno :::");
      print(" E R R IS $e");
      return {
        "title": "Network Error",
        "message": "Please check your internet connection"
      };
    } else {
      print("U N K N O W N ERROR IS $e");
      return {
        "title": "Something went wrong",
        "message":
            "Please contact us with a description of what you were doing before you saw this message."
      };
    }
  }

  String toJson() => json.encode(toMap());

  factory AppError.fromJson(String source) =>
      AppError.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppError(title: $title, content: $content)';
}
