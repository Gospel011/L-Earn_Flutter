// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_cubit.dart';

class PostState {
  final int? page;
  final Post? post; //* For getting post by id
  final AppError? error;
  final List<Post>? newPosts;
  final List<Post>? posts;

  const PostState(
      {this.page, this.posts, this.post, this.error, this.newPosts});

  PostState copyWith({
    int? page,
    Post? post,
    AppError? error,
    List<Post>? newPosts,
    List<Post>? posts, //* re
  }) {
    return PostState(
      page: page ?? this.page,
      post: post ?? this.post,
      error: error ?? this.error,
      newPosts: newPosts ?? this.newPosts,
      posts: posts ?? this.posts,
    );
  }

  @override
  String toString() => 'PostState(page: $page, post: $post, error: $error)';
}

class NewPostsLoaded extends PostState {
  const NewPostsLoaded({required super.page, required super.newPosts});
}

class NewPostsLoading extends PostState {
  const NewPostsLoading({required super.page});
}

class NewPostsFailed extends PostState {
  const NewPostsFailed({super.page, required super.newPosts, required super.error});
}

class RequestingPostById extends PostState {
  const RequestingPostById({required super.page, required super.post});
}

class RequestingPostByIdFailed extends PostState {
  const RequestingPostByIdFailed({required super.page, required super.error});
}

class CreatingNewPost extends PostState {
  const CreatingNewPost({super.newPosts});
}

class NewPostCreated extends PostState {
  const NewPostCreated({ required super.newPosts});
}

class CreatingNewPostFailed extends PostState {
  const CreatingNewPostFailed({super.newPosts});
}
