// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'like_cubit.dart';
// import 'dart:convert';

abstract class LikeState {
  final int likes;
  final bool liked;
  final AppError? error;
  const LikeState({
    required this.likes,
    required this.liked,
    this.error
  });

  @override
  String toString() => 'LikeState(likes: $likes, liked: $liked)';

  @override
  bool operator ==(covariant LikeState other) {
    if (identical(this, other)) return true;

    return other.likes == likes && other.liked == liked;
  }

  @override
  int get hashCode => likes.hashCode ^ liked.hashCode;
}

class LikeInitial extends LikeState {
  const LikeInitial({required super.likes, required super.liked});
}

class Liking extends LikeState {
  const Liking({required super.likes, required super.liked});
}

class Liked extends LikeState {
  const Liked({required super.likes, required super.liked});
}

class LikingFailed extends LikeState {
  const LikingFailed({required super.likes, required super.liked, super.error});
}
