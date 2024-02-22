// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:l_earn/DataLayer/Models/article_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/DataLayer/Models/video_model.dart';

class Content {
  final String id;
  final User author;
  final String type;
  final String title;
  final String thumbnailUrl;
  final String? description;
  final double? averageRating;
  final int? numberOfRatings;
  final int price;
  final int videos;
  final int articles;
  final List<Video>? videoChapters;
  final List<Article>? bookChapters;
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
    this.videoChapters,
    this.bookChapters,
    required this.students,
    required this.dateCreated,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'authorId': author.toMap(),
      'type': type,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'averageRating': averageRating,
      'numberOfRatings': numberOfRatings,
      'price': price,
      'videos': videos,
      'articles': articles,
      'videoChapters': videoChapters?.map((x) => x.toMap()).toList(),
      'bookChapters': bookChapters?.map((x) => x.toMap()).toList(),
      'students': students,
      'dateCreated': dateCreated,
      'tags': tags,
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['_id'] as String,
      author: User.fromMap(map['authorId'] as Map<String,dynamic>),
      type: map['type'] as String,
      title: map['title'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      averageRating: map['averageRating'] != null ? double.parse(map['averageRating'].toString())  : null,
      numberOfRatings: map['numberOfRatings'] != null ? int.parse(map['numberOfRatings'].toString()) : null,
      price: map['price'] as int,
      videos: map['videos'] as int,
      articles: map['articles'] as int,
      videoChapters: map['videoChapters'] != null ? List<Video>.from((map['videoChapters'] as List<dynamic>).map<Video?>((x) => Video.fromMap(x as Map<String,dynamic>),),) : null,
      bookChapters: map['bookChapters'] != null ? List<Article>.from((map['bookChapters'] as List<dynamic>).map<Article?>((x) => Article.fromMap(x as Map<String,dynamic>),),) : null,
      students: map['students'] as int,
      dateCreated: map['dateCreated'] as String,
      tags: map['tags'] != null ? List<String>.from((map['tags'] as List<dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Content.fromJson(String source) =>
      Content.fromMap(json.decode(source) as Map<String, dynamic>);

  Content copyWith({
    String? id,
    User? author,
    String? type,
    String? title,
    String? thumbnailUrl,
    String? description,
    double? averageRating,
    int? numberOfRatings,
    int? price,
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
    return 'Content(id: $id, author: $author, type: $type, title: $title, thumbnailUrl: $thumbnailUrl, averageRating: $averageRating, numberOfRatings: $numberOfRatings, price: $price, videos: $videos, articles: $articles, videoChapters: $videoChapters, bookChapters: $bookChapters, students: $students, dateCreated: $dateCreated, tags: $tags)';
  }
}
