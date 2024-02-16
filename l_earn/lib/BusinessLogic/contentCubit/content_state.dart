// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'content_cubit.dart';

abstract class ContentState {

  /// This is the list of contents found, it is required for ALL content states
  final List<Content> contents;

  /// This is the content found when it is was requested by it's id
  final Content? content;

  /// This is the type for the content, whether playlist or book
  final String? type;

  /// This is a chapter for a book
  final Article? article;

  /// This is a chapter fo a playlist
  final Video? video;

  /// This is the error encountered when making network request
  final AppError? error;


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

/// State indicating that a chapter is being requested by it's id
class RequestingChapterById extends ContentState {
  const RequestingChapterById({required super.contents, required super.content});
}

/// State indicating that the requested chapter was found
class ChapterFound extends ContentState {
  const ChapterFound(
      {required super.contents,
      required super.content,
      required super.type,
      super.article,
      super.video
      });
}

/// State indicating that the requested chapter was not foundd
class ChapterNotFound extends ContentState {
  const ChapterNotFound({required super.contents, required super.content, required super.error});
}
