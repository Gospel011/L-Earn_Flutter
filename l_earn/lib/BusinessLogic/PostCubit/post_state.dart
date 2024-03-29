// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_cubit.dart';

class PostState {
  final int? page;
  final Post? post; //* For getting post by id
  final AppError? error;
  final List<Post> newPosts;
  final List<Post>? posts;

  const PostState(
      {this.page, this.posts, this.post, this.error, required this.newPosts});

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
  const NewPostsLoading({required super.page, required super.newPosts});
}

class NewPostsFailed extends PostState {
  const NewPostsFailed({super.page, required super.newPosts, required super.error});
}

class RequestingPostById extends PostState {
  const RequestingPostById({required super.page, required super.post, required super.newPosts});
}

class RequestingPostByIdFailed extends PostState {
  const RequestingPostByIdFailed({required super.page, required super.error, required super.newPosts});
}

class CreatingNewPost extends PostState {
  const CreatingNewPost({required super.newPosts});
}

class NewPostCreated extends PostState {
  const NewPostCreated({ required super.newPosts});
}

class CreatingNewPostFailed extends PostState {
  const CreatingNewPostFailed({required super.newPosts});
}

class GettingMyPost extends PostState {
  const GettingMyPost({required super.newPosts, required super.posts});
}

class MyPostFound extends PostState {
  const MyPostFound({required super.newPosts, required super.posts});
}


class GettingMyPostFailed extends PostState {
  const GettingMyPostFailed({required super.newPosts, required super.posts});
}
class GettingPost extends PostState {
  const GettingPost({required super.newPosts, required super.posts});
}

class PostFound extends PostState {
  const PostFound({required super.newPosts, required super.posts, required super.post});
}


class GettingPostFailed extends PostState {
  const GettingPostFailed({required super.newPosts, required super.posts, required super.error});
}