// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'comment_cubit.dart';


abstract class CommentState {
  final int page;
  final List<Comment> comments;
  CommentState({
    required this.page,
    required this.comments,
  });
}


class CommentsInitial extends CommentState {
  CommentsInitial({required super.page, required super.comments});
}
class CommentsLoading extends CommentState {
  CommentsLoading({required super.page, required super.comments});
}
class CommentsLoaded extends CommentState {
  CommentsLoaded({required super.page, required super.comments});
}
class CommentLoadingFailed extends CommentState {
  CommentLoadingFailed({required super.page, required super.comments});
}
class CommentPosting extends CommentState {
  CommentPosting({required super.page, required super.comments});
}
class CommentPostingFailed extends CommentState {
  CommentPostingFailed({required super.page, required super.comments});
}
class CommentPosted extends CommentState {
  CommentPosted({required super.page, required super.comments});
}