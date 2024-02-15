// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'content_cubit.dart';

abstract class ContentState {
  final List<Content> contents;
  final Content? content;
  final String? type;
  final Article? article;
  final Video? video;
  final AppError? error;
  //article
  //video
  const ContentState(
      {required this.contents,
      this.content,
      this.type,
      this.article,
      this.video,
      this.error});
}

/// Initial state when ContentCubit is first initialized
class ContentInitial extends ContentState {
  const ContentInitial({required super.contents});
}

/// State indicating that some content is loading
class ContentLoading extends ContentState {
  const ContentLoading({required super.contents});
}

/// State indicating that comments is loaded
class ContentLoaded extends ContentState {
  const ContentLoaded({required super.contents});
}

/// State indicating that content loading failed
class ContentLoadingFailed extends ContentState {
  const ContentLoadingFailed({required super.contents, required super.error});
}

/// State indicating that a content is being requested by it's id
class RequestingContentById extends ContentState {
  const RequestingContentById({required super.contents});
}

/// State indicating that the requested content was found
class ContentFound extends ContentState {
  const ContentFound(
      {required super.contents,
      required super.type,
      required super.content
      });
}

/// State indicating that the requested content was not foundd
class ContentNotFound extends ContentState {
  const ContentNotFound({required super.contents, required super.error});
}
