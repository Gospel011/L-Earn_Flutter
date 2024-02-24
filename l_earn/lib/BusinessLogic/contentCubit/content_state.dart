// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'content_cubit.dart';

abstract class ContentState {

  /// This is the list of contents found, it is required for ALL content states
  final List<Content> contents;

  /// This is the list of contents posted by a specified user found, it is required for ALL content states
  final List<Content>? myContents;

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
      required this.myContents,
      this.content,
      this.type,
      this.article,
      this.video,
      this.error});
}

/// Initial state when ContentCubit is first initialized
class ContentInitial extends ContentState {
  const ContentInitial({required super.contents, required super.myContents});
}

/// State indicating that some content is loading
class ContentLoading extends ContentState {
  const ContentLoading({required super.contents, required super.myContents});
}

/// State indicating that comments is loaded
class ContentLoaded extends ContentState {
  const ContentLoaded({required super.contents, super.content, required super.myContents});
}

/// State indicating that content loading failed
class ContentLoadingFailed extends ContentState {
  const ContentLoadingFailed({required super.contents, required super.error, required super.myContents});
}

/// State indicating that a content is being requested by it's id
class RequestingContentById extends ContentState {
  const RequestingContentById({required super.contents, required super.myContents});
}

/// State indicating that the requested content was found
class ContentFound extends ContentState {
  const ContentFound(
      {required super.contents,
      required super.type,
      required super.content,
      required super.myContents
      });
}

/// State indicating that the requested content was not foundd
class ContentNotFound extends ContentState {
  const ContentNotFound({required super.contents, required super.error, required super.myContents});
}

/// State indicating that a chapter is being requested by it's id
class RequestingChapterById extends ContentState {
  const RequestingChapterById({required super.contents, required super.content, super.article, super.video, required super.myContents});
}

/// State indicating that the requested chapter was found
class ChapterFound extends ContentState {
  const ChapterFound(
      {required super.contents,
      required super.myContents,
      required super.content,
      required super.type,
      super.article,
      super.video
      });
}

/// State indicating that the requested chapter was not found
class ChapterNotFound extends ContentState {
  const ChapterNotFound({required super.contents, required super.myContents, required super.content, required super.error, super.article, super.video});
}

/// State indicating that a content is being initialized. For example, if it is 
/// a book, this state is saying that the book is being created.
class InitializingContent extends ContentState {


  InitializingContent({required super.contents, required super.myContents});
}

/// State indicating that a content has been created. Again, if it is a book,
/// this state is saying that it has been created on the server.
class ContentCreated extends ContentState {


  ContentCreated({required super.contents, required super.myContents});
}

  /// State indicating that the content creation failed
class InitializingContentFailed extends ContentState {

  InitializingContentFailed({required super.contents, required super.myContents, required super.error});
}

/// State indicating that a content is being edited. For example, if it is 
/// a book, this state is saying that the book is being edited on the server.
class EditingContent extends ContentState {


  EditingContent({required super.contents, required super.myContents});
}

/// State indicating that a content has been edited. Again, if it is a book,
/// this state is saying that it has been edited on the server.
class ContentEdited extends ContentState {


  ContentEdited({required super.contents, required super.myContents});
}

  /// State indicating that the content edit operation failed
class EditingContentFailed extends ContentState {

  EditingContentFailed({required super.contents, required super.myContents, required super.error});
}

/// State indicating that a chapter is being added to a content
class CreatingChapter extends ContentState {


  CreatingChapter({required super.contents, required super.myContents});
}

/// State indicating that a chapter has been created
class ChapterCreated extends ContentState {


  ChapterCreated({required super.contents, required super.myContents});
}

  /// State indicating that the chapter creation operation failed
class ChapterCreationFailed extends ContentState {

  ChapterCreationFailed({required super.contents, required super.myContents, required super.error});
}

/// State indicating that a content is being deleted
class DeletingContent extends ContentState {


  DeletingContent({required super.contents, required super.myContents});
}

/// State indicating that a content has been deleted
class ContentDeleted extends ContentState {


  ContentDeleted({required super.contents, required super.myContents});
}

  /// State indicating that the content delete operation failed
class DeletingContentFailed extends ContentState {

  DeletingContentFailed({required super.contents, required super.myContents, required super.error});
}