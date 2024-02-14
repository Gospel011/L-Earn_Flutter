// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:l_earn/DataLayer/Models/user_model.dart';

class Content {
  final String id;
  final User author;
  final String type;
  final String title;
  final String thumbnailUrl;
  final String? description;
  final String? averageRating;
  final String? numberOfRatings;
  final String price;
  final int videos;
  final int articles;
  final int students;
  final String dateCreated;
  final List<String>? tags;
  
  Content({
    required this.id,
    required this.author,
    required this.type,
    required this.title,
    required this.thumbnailUrl,
    this.description,
    this.averageRating,
    this.numberOfRatings,
    required this.price,
    required this.videos,
    required this.articles,
    required this.students,
    required this.dateCreated,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'author': author.toMap(),
      'type': type,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'averageRating': averageRating,
      'numberOfRatings': numberOfRatings,
      'price': price,
      'videos': videos,
      'articles': articles,
      'students': students,
      'dateCreated': dateCreated,
      'tags': tags,
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['id'] as String,
      author: User.fromMap(map['author'] as Map<String,dynamic>),
      type: map['type'] as String,
      title: map['title'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      averageRating: map['averageRating'] != null ? map['averageRating'] as String : null,
      numberOfRatings: map['numberOfRatings'] != null ? map['numberOfRatings'] as String : null,
      price: map['price'] as String,
      videos: map['videos'] as int,
      articles: map['articles'] as int,
      students: map['students'] as int,
      dateCreated: map['dateCreated'] as String,
      tags: map['tags'] != null ? List<String>.from((map['tags'] as List<String>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Content.fromJson(String source) => Content.fromMap(json.decode(source) as Map<String, dynamic>);

  Content copyWith({
    String? id,
    User? author,
    String? type,
    String? title,
    String? thumbnailUrl,
    String? description,
    String? averageRating,
    String? numberOfRatings,
    String? price,
    int? videos,
    int? articles,
    int? students,
    String? dateCreated,
    List<String>? tags,
  }) {
    return Content(
      id: id ?? this.id,
      author: author ?? this.author,
      type: type ?? this.type,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      description: description ?? this.description,
      averageRating: averageRating ?? this.averageRating,
      numberOfRatings: numberOfRatings ?? this.numberOfRatings,
      price: price ?? this.price,
      videos: videos ?? this.videos,
      articles: articles ?? this.articles,
      students: students ?? this.students,
      dateCreated: dateCreated ?? this.dateCreated,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'Content(id: $id, author: $author, type: $type, title: $title, thumbnailUrl: $thumbnailUrl, description: $description, averageRating: $averageRating, numberOfRatings: $numberOfRatings, price: $price, videos: $videos, articles: $articles, students: $students, dateCreated: $dateCreated, tags: $tags)';
  }
}
