// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'content_cubit.dart';

abstract class ContentState {
  final List<Content> contents;
  final AppError? error;
  //article
  //video
  const ContentState({
    required this.contents,
    this.error
  });

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
