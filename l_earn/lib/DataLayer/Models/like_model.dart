// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Like {
  final int likes;
  final bool liked;
  
  const Like({required this.likes, required this.liked});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'likes': likes,
      'liked': liked,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      likes: map['likes'] as int,
      liked: map['liked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Like.fromJson(String source) => Like.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Like(likes: $likes, liked: $liked)';

  Like copyWith({
    int? likes,
    bool? liked,
  }) {
    return Like(
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
    );
  }
}
