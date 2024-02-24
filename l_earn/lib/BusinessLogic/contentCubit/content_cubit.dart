import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:l_earn/DataLayer/Models/article_model.dart';

import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/video_model.dart';
import 'package:l_earn/DataLayer/Repositories/content_repo.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  ContentCubit() : super(const ContentInitial(contents: [], myContents: []));
  int currentPage = 0;

  Future<void> loadContents(token,
      {int? page, String? userId, int userPage = 1}) async {
    currentPage++;
    if (page != null) currentPage = page;

    List<Content> contents = [...state.contents];

    emit(ContentLoading(contents: contents, myContents: state.myContents));

    final response = await ContentRepo.loadContents(
        token, userId != null ? userPage : currentPage,
        userId: userId);

    print("________CONTENT CUBIT RESOPONSE $response");

    if (response is List<Content>) {
      // print("contents____________$contents");
      // print("page______$currentPage");

      if (page == null && userId == null) contents.addAll(response);

      List<Content> userContents = [...?state.myContents] ?? [];

      if (userId != null) userContents.addAll(response);

      if (userId == null) {
        emit(ContentLoaded(
            contents: page != null ? response : contents,
            myContents: state.myContents));
      } else {
        emit(ContentLoaded(
            contents: page != null ? response : contents,
            myContents: response));
      }

      if (response.isEmpty) {
        currentPage--;
      }
    } else {
      currentPage--;
      emit(ContentLoadingFailed(
          contents: contents,
          error: response as AppError,
          myContents: state.myContents));
    }
  }

  Future<void> getContentById(token, id) async {
    emit(RequestingContentById(
        contents: state.contents, myContents: state.myContents));

    final response = await ContentRepo.getContentById(token, id);

    // print("::: T A R G E T   C O N T E N T   IS   $response");

    if (response is Content) {
      emit(ContentFound(
          contents: state.contents,
          type: response is Article ? 'book' : 'video',
          myContents: state.myContents,
          content: response));
    } else {
      emit(ContentNotFound(
          contents: state.contents,
          error: response as AppError,
          myContents: state.myContents));
    }
  }

  Future<void> getChapterById(
      {required token,
      required chapterId,
      required contentId,
      required type}) async {
    emit(RequestingChapterById(
        contents: state.contents,
        myContents: state.myContents,
        content: state.content,
        article: state.article));

    // print("T O K E N   I S   $token");

    final response = await ContentRepo.getChapterById(
        token: token, chapterId: chapterId, contentId: contentId, type: type);

    print(
        "R E S P O N S E   F R O M   C O N T E N T   C U B I T   I S   $response");

    if (response is Article) {
      // print("::::: E M I T T I N G   S T A T E");
      emit(ChapterFound(
          contents: state.contents,
          content: state.content,
          myContents: state.myContents,
          type: type,
          article: response));
    } else if (response is Video) {
      emit(ChapterFound(
          contents: state.contents,
          myContents: state.myContents,
          content: state.content,
          type: type,
          video: response));
    } else {
      emit(ChapterNotFound(
          contents: state.contents,
          content: state.content,
          myContents: state.myContents,
          error: response as AppError,
          article: state.article,
          video: state.video));
    }
  }

  Future<void> initializeBook(token, Map<String, dynamic> details) async {
    emit(InitializingContent(
        contents: state.contents, myContents: state.myContents));

    final response = await ContentRepo.initializeBook(token, details);

    if (response == 'success') {
      emit(ContentCreated(
          contents: state.contents, myContents: state.myContents));
    } else {
      emit(InitializingContentFailed(
          contents: state.contents,
          myContents: state.myContents,
          error: response as AppError));
    }
  }

  Future<void> editBook(token, Map<String, dynamic> details,
      {required String id}) async {
    emit(
        EditingContent(contents: state.contents, myContents: state.myContents));

    final response = await ContentRepo.initializeBook(token, details,
        method: 'PATCH', id: id);

    if (response == 'success') {
      emit(ContentEdited(
          contents: state.contents, myContents: state.myContents));
    } else {
      emit(EditingContentFailed(
          contents: state.contents,
          myContents: state.myContents,
          error: response as AppError));
    }
  }

  Future<void> createChapter(
      {required token,
      required Map<String, String> details,
      required String contentId,
      String? chapterId}) async {
    emit(CreatingChapter(
        contents: state.contents, myContents: state.myContents));

    final response = await ContentRepo.createChapter(token, details,
        contentId: contentId, chapterId: chapterId);

    if (response == 'success') {
      emit(ChapterCreated(
          contents: state.contents, myContents: state.myContents));
    } else {
      emit(ChapterCreationFailed(
          contents: state.contents,
          myContents: state.myContents,
          error: response as AppError));
    }
  }

  Future<void> deleteBook(token, {required String id}) async {
    emit(DeletingContent(
        contents: state.contents, myContents: state.myContents));

    final response =
        await ContentRepo.initializeBook(token, {}, method: 'DELETE', id: id);

    print("D E L E T E   R E S P O N S E   I S   $response");

    if (response == 'success') {
      emit(ContentDeleted(
          contents: state.contents, myContents: state.myContents));
    } else {
      emit(DeletingContentFailed(
          contents: state.contents,
          myContents: state.myContents,
          error: response as AppError));
    }
  }
}
